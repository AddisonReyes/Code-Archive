import logging
import random

logging.basicConfig(
    level=logging.DEBUG, format="%(asctime)s - %(levelname)s - %(message)s"
)


def main():
    guess: str = ""

    while guess not in ["heads", "tails"]:
        logging.info("Guess the coin toss! Enter heads or tails: ")
        guess = input().lower()

    toss: str = random.choice(["heads", "tails"])
    if guess == toss:
        logging.info("You got it!")
    else:
        logging.info("Nope! It was %s.", toss)


if __name__ == "__main__":
    main()
