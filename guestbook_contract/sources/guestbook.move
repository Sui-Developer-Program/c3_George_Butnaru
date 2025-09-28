/*
/// Module: guestbook
module guestbook::guestbook;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module guestbook::guestbook;

public struct Message has store {
    content: vector<u8>,
    author: address,
}

public struct GuestBook has key {
    id: UID,
    messages: vector<Message>,
    no_of_messages: u64,
}

fun init(ctx: &mut TxContext) { 
    let guestbook: GuestBook = GuestBook {
        id: object::new(ctx),
        messages: vector::empty<Message>(),
        no_of_messages: 0
    };
    sui::transfer::share_object(guestbook);
}

public fun post_message(message: Message, guestbook: &mut GuestBook) {
    vector::push_back(&mut guestbook.messages, message);
    guestbook.no_of_messages = guestbook.no_of_messages + 1;
}

const MAX_LENGTH : u64 = 300;
public fun create_message(content: vector<u8>, ctx:  &mut TxContext): Message {
    assert!(content.length() <= MAX_LENGTH, 1);
    let sender = ctx.sender();
    Message {
        content,
        author : sender,
    }
}

// PTB