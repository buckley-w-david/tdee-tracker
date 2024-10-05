import csv

with open("en.openfoodfacts.org.products.csv", "r", newline="") as r, open(
    "openfoodfacts-products.csv", "w"
) as w:
    products = csv.reader(r, delimiter="\t", quoting=csv.QUOTE_NONE)
    next(products)  # Skip the header

    output = csv.writer(w)
    output.writerow(["name", "kilocalories", "quantity", "unit"])
    for i, product in enumerate(products):
        if i % 10000 == 0:
            print(f"Processed {i} products...")
        kilojouls = product[89]
        if not kilojouls:
            continue
        kilocalories = int(float(kilojouls) * 0.239)

        name = product[10].strip()
        if not name:
            continue

        brand = product[18].strip()
        if brand:
            name = f"{brand} {name}"

        output.writerow([name, kilocalories, 100, "g"])
