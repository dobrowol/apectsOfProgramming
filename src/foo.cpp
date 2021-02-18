#include "rotor.hpp"
#include "rotor/asio.hpp"
#include <iostream>
#include <cmath>
#include <system_error>

namespace asio = boost::asio;
namespace pt = boost::posix_time;

namespace payload {
struct sample_res_t {
    double value;
};
struct sample_req_t {
    using response_t = sample_res_t;
    double value;
};
} // namespace payload

namespace message {
using request_t = rotor::request_traits_t<payload::sample_req_t>::request::message_t;
using response_t = rotor::request_traits_t<payload::sample_req_t>::response::message_t;
} // namespace message

struct server_actor : public rotor::actor_base_t {
    using rotor::actor_base_t::actor_base_t;

    void configure(rotor::plugin::plugin_base_t &plugin) noexcept override {
        rotor::actor_base_t::configure(plugin);
        plugin.with_casted<rotor::plugin::starter_plugin_t>(
            [](auto &p) { p.subscribe_actor(&server_actor::on_request); });
    }

    void on_request(message::request_t &req) noexcept {
        auto in = req.payload.request_payload.value;
        if (in >= 0) {
            auto value = std::sqrt(in);
            reply_to(req, value);
        } else {
            // IRL, it should be your custom error codes
            auto ec = std::make_error_code(std::errc::invalid_argument);
            reply_with_error(req, ec);
        }
    }
};

struct client_actor : public rotor::actor_base_t {
    using rotor::actor_base_t::actor_base_t;

    rotor::address_ptr_t server_addr;

    void set_server(const rotor::address_ptr_t addr) { server_addr = addr; }

    void configure(rotor::plugin::plugin_base_t &plugin) noexcept override {
        rotor::actor_base_t::configure(plugin);
        plugin.with_casted<rotor::plugin::starter_plugin_t>(
            [](auto &p) { p.subscribe_actor(&client_actor::on_response); });
    }

    void on_response(message::response_t &res) noexcept {
        if (!res.payload.ec) { // check for possible error
            auto &in = res.payload.req->payload.request_payload.value;
            auto &out = res.payload.res.value;
            std::cout << " in = " << in << ", out = " << out << "\n";
        }
        supervisor->do_shutdown(); // optional;
    }

    void on_start() noexcept override {
        rotor::actor_base_t::on_start();
        auto timeout = rotor::pt::milliseconds{1};
        request<payload::sample_req_t>(server_addr, 25.0).send(timeout);
    }
};

int main() {
    asio::io_context io_context;
    auto system_context = rotor::asio::system_context_asio_t::ptr_t{new rotor::asio::system_context_asio_t(io_context)};
    auto strand = std::make_shared<asio::io_context::strand>(io_context);
    auto timeout = boost::posix_time::milliseconds{500};
    auto sup =
        system_context->create_supervisor<rotor::asio::supervisor_asio_t>().strand(strand).timeout(timeout).finish();
    auto server = sup->create_actor<server_actor>().timeout(timeout).finish();
    auto client = sup->create_actor<client_actor>().timeout(timeout).finish();
    client->set_server(server->get_address());
    sup->do_process();
    return 0;
}
