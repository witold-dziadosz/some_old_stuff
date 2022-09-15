import pandas as pd
import math
eur = 4.64
usd = 4.28
if __name__ == "__main__":
    positions = []
    companies = []
    low_wages = []
    high_wages =[]
    with open("./oferty.txt", "r") as f:
        cnt = 5
        for line in f.readlines():
            try:
                splitted = line[2:].split(":")
                pos_comp = splitted[0]
                money = splitted[1]

                position, company = pos_comp.split("/")
                company = company.strip()
                money = money.strip()
                
                
                print(position, "-->", company)
                money_split = money.replace("K", "").split(" ")
                
                low_wage, high_wage = money_split[0].split('-')
                low_wage = float(low_wage) * 1000.0
                high_wage = float(high_wage) * 1000.0
                

                if len(money_split) == 2:
                    multiplier = 1
                    if money_split[1].strip() == "EUR":
                        multiplier = eur
                    elif money_split[1].strip() == "USD":
                        multiplier = usd
                    low_wage = low_wage * multiplier
                    low_wage = round(low_wage)
                    high_wage = high_wage * multiplier
                    high_wage = round(high_wage)

                positions.append(position)
                companies.append(company)
                low_wages.append(low_wage)
                high_wages.append(high_wage)
            except:
                pass

        df = pd.DataFrame({
            "position" : positions,
            "company" : companies,
            "low_wage" : low_wages,
            "high_wage" : high_wages
        })

        df["mid_wage"] = 0.5 * (df.low_wage + df.high_wage)

        print(df.head())
        df.to_csv("oferty-junior.csv")
