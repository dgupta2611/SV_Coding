def Leapyear(year):

    if(year%4 == 0 and year%100 != 0):
        if(year%400 == 0):
            print("It is a Leapyear")
    elif(year%4 == 0):
        print("It is a Leapyear")

print(Leapyear(1900))
print(Leapyear(2000))
print(Leapyear(2024))
print(Leapyear(1300))
