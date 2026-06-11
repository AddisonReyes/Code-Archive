def box_print(symbol, width, height):
    if len(symbol) != 1:
        raise Exception("Symbol must be a single character string.")
    if width <= 2:
        raise Exception("Width must be greater than 2.")
    if height <= 2:
        raise Exception("Height must be greater than 2.")

    print(f"symbol: {symbol}, {width} x {height}")
    print(symbol * width)

    for i in range(height - 2):
        print(symbol + (" " * (width - 2)) + symbol)

    print(symbol * width, "\n")


def main():
    try:
        box_print("*", 4, 4)
        box_print("O", 20, 5)
        box_print("x", 1, 3)
        box_print("zz", 3, 3)
    except Exception as err:
        print("An exception happened: " + str(err))

    try:
        box_print("zz", 3, 3)
    except Exception as err:
        print("An exception happened: " + str(err))


if __name__ == "__main__":
    main()
