import logging

logging.basicConfig(
    filename="factorial_program.txt",
    level=logging.DEBUG,
    format="%(asctime)s - %(levelname)s - %(message)s",
)


def factorial(n: int) -> int:
    logging.debug(f"Start of factorial({n})")
    total = 1

    for i in range(1, n + 1):
        total *= i
        logging.debug(f"i is {i}, total is {total}")

    logging.debug(f"End of factorial({n})")
    return total


def main():
    factorial(5)
    logging.debug("End of program.")


if __name__ == "__main__":
    main()
