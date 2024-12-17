def SR(register, MSBin, LSBin, direction = 'LSL'):

    i = 0

    if direction == 'LSL':
        register.pop(0)
        print(register)
        register.append(LSBin)
    elif direction == 'LSR':
        register.pop(-1)
        print(register)
        register.insert(0, MSBin)
    elif direction == 'RL':
        i = register.pop(0)
        print(register)
        register.insert(-1, i)
    elif direction == 'RR':
        i = register.pop(-1)
        print(register)
        register.insert(0, i)
    elif direction == 'ASL':
        register.pop(0)
        print(register)
        register.insert(-1, 0)
    elif direction == 'ASR':
        register.pop(-1)
        print(register)
        register.insert(0, register[0])
    else:
        register = register
    
    return register


register = [0, 1, 1, 0]
MSBin = 1
LSBin = 1
direction = 'None'
Shiftregister = SR(register, MSBin, LSBin, direction)
print(Shiftregister)
    




    