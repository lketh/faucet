use sha3::{Digest, Sha3_256};
use yew::prelude::*;

#[path = "../components/mod.rs"]
mod components;

use components::text_input::TextInput;

#[derive(Debug, Default)]
pub struct Home {
    address: String,
    valid_address: bool,
}

pub enum Msg {
    SetAddress(String),
}

fn validate_eth_address(address: String) -> bool {
    if address.clone().len() < 42 && !address.clone().starts_with("0x") {
        return false;
    }

    let check = eth_checksum_encode(address.to_lowercase());

    check.clone().to_lowercase() == address.to_lowercase().to_lowercase()
}

fn eth_checksum_encode(address: String) -> String {
    let input = String::from(address.to_ascii_lowercase().trim_start_matches("0x"));
    let mut hasher = Sha3_256::new();
    hasher.update(input);
    let hex = hasher.finalize();
    let mut ret = String::with_capacity(42);
    ret.push_str("0x");
    for i in 0..40 {
        let letter = u32::from_str_radix(&hex[1].to_string(), 16);
        if letter.unwrap() > 7 {
            ret.push_str(&address[i + 2..i + 3].to_ascii_uppercase());
        } else {
            ret.push_str(&address[i + 2..i + 3]);
        }
    }
    ret
}

impl Component for Home {
    type Message = Msg;
    type Properties = ();

    fn create(_ctx: &Context<Self>) -> Self {
        Self::default()
    }

    fn view(&self, _ctx: &Context<Self>) -> Html {
        html! {
          <div class="tile is-ancestor is-vertical">
            <div class="tile is-child hero">
              <div class="hero-body container pb-0">
                <h1 class="title is-1">{ "Rusty Faucet" }</h1>
              </div>
            </div>

            <div class="tile is-parent container">
              { self.view_info_tiles(_ctx) }
            </div>

            <div class="columns">
              <div class="column is-8 is-offset-2">
                <div class="tile is-parent is-half">
                <div class="tile is-parent">
                  <div class="tile is-child box">
                    <p class="title">{ "Faucet details" }</p>
                    <p class="subtitle">{ "" }</p>

                    <div class="content">
                      <div class="box">
                        <p><span class="detail-item">{"Address: "}</span><a href="#">{ "0xB6eD7644C69416d67B522e20bC294A9a9B405B31" }</a></p>
                        <p><span class="detail-item">{"In: "}</span><a href="#">{ "5" }</a></p>
                        <p><span class="detail-item">{"Out: "}</span><a href="#">{ "15" }</a></p>
                        <p><span class="detail-item">{"Pooling: "}</span><a href="#">{ "10" }</a></p>
                        <p><span class="detail-item">{"Generated: "}</span><a href="#">{ "3" }</a></p>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="tile is-parent is-half">
                  <div class="tile is-child box">
                    <p class="title">{ "Latest events" }</p>
                    <p class="subtitle">{ "" }</p>

                    <div class="content">
                      <div class="box">
                        <p><a href="#"><span class="detail-item">{"0x67a7249817d976c3783d6b4bba5dfd716d98da896b88f574c160413bc68137c1"}</span></a></p>
                        <p><a href="#"><span class="detail-item">{"0x67a7249817d976c3783d6b4bba5dfd716d98da896b88f574c160413bc68137c1"}</span></a></p>
                        <p><a href="#"><span class="detail-item">{"0x67a7249817d976c3783d6b4bba5dfd716d98da896b88f574c160413bc68137c1"}</span></a></p>
                        <p><a href="#"><span class="detail-item">{"0x67a7249817d976c3783d6b4bba5dfd716d98da896b88f574c160413bc68137c1"}</span></a></p>
                        <p><a href="#"><span class="detail-item">{"0x67a7249817d976c3783d6b4bba5dfd716d98da896b88f574c160413bc68137c1"}</span></a></p>
                        <p><a href="#"><span class="detail-item">{"0x67a7249817d976c3783d6b4bba5dfd716d98da896b88f574c160413bc68137c1"}</span></a></p>
                        <p><a href="#"><span class="detail-item">{"0x67a7249817d976c3783d6b4bba5dfd716d98da896b88f574c160413bc68137c1"}</span></a></p>
                      </div>
                    </div>
                  </div>
                </div>
                </div>
              </div>
            </div>
          </div>
        }
    }

    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::SetAddress(address) => {
                self.address = address
                    .clone()
                    .to_lowercase()
                    .chars()
                    .filter(|c| !c.is_whitespace())
                    .collect();
                self.valid_address = validate_eth_address(address.clone().to_lowercase());
            }
        };
        true
    }
}

impl Home {
    fn view_info_tiles(&self, _ctx: &Context<Self>) -> Html {
        let on_change = _ctx.link().callback(Msg::SetAddress);
        let extra_class = if self.valid_address {
            "is-success"
        } else {
            "is-danger"
        };
        html! {
          <>
            <div class="tile is-parent">
              <div class="tile is-child box">
                <p class="title">{ "" }</p>
                <p class="subtitle">{ "Put your address to get some ether, if you have some extra ether please donate it here for others to be able to use the test network" }</p>

                <div class="content">
                  <div>
                    <TextInput {on_change} extra_class={extra_class}  value={self.address.clone()} />
                  </div>
                </div>
              </div>
            </div>

          </>
        }
    }
}
