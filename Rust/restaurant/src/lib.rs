mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}

        #[allow(dead_code)]
        fn seat_at_table() {}
    }

    mod serving {
        #[allow(dead_code)]
        fn take_order() {}

        #[allow(dead_code)]
        fn serve_order() {}

        #[allow(dead_code)]
        fn take_payment() {}
    }
}

use crate::front_of_house::hosting;

#[allow(dead_code)]
fn deliver_order() {}

mod back_of_house {
    pub enum Appetizer {
        Soup,
        Salad,
    }

    pub struct Breakfast {
        pub toast: String,
        seasonal_fruit: String,
    }

    impl Breakfast {
        pub fn summer(toast: &str) -> Breakfast {
            Breakfast {
                toast: String::from(toast),
                seasonal_fruit: String::from("peaches"),
            }
        }
    }

    #[allow(dead_code)]
    fn fix_incorrect_order() {
        cook_order();
        super::deliver_order();
    }

    #[allow(dead_code)]
    fn cook_order() {}
}

#[allow(unused)]
pub fn eat_at_restaurant() {
    // Order a breakfast in the summer with Rye toast
    let mut meal = back_of_house::Breakfast::summer("Rye");

    // Change our mind about what bread we'd like
    meal.toast = String::from("Wheat");
    println!("I'd like {} toast please", meal.toast);

    let order1 = back_of_house::Appetizer::Soup;
    let order2 = back_of_house::Appetizer::Salad;

    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();

    // Shortcut path
    hosting::add_to_waitlist();
}
