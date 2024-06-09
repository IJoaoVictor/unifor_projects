import re

def estados(placa):
    class PR:
        def __init__(self, placa):
            self.regexes = [
                "^A[A-Z]{2}[0-9][A-Z][0-9][0-9]$",  # AAA a BEZ
                "^B[A-E][A-Z][0-9][A-Z][0-9][0-9]$",
                "^RHA[0-9][A-Z][0-9][0-9]$",        # RHA a RHZ
                "^RH[B-Z][0-9][A-Z][0-9][0-9]$"
            ]
            self.matches = any(re.match(regex, placa) for regex in self.regexes)

    class RS:
        def __init__(self, placa):
            self.regexes = [
                "^IAQ[0-9][A-Z][0-9][0-9]$",  # IAQ a JDO
                "^I[A-Z]{2}[0-9][A-Z][0-9][0-9]$",  # IAQ a JDO
                "^J[A-C][A-O][0-9][A-Z][0-9][0-9]$"
            ]
            self.matches = any(re.match(regex, placa) for regex in self.regexes)

    class SC:
        def __init__(self, placa):
            self.regexes = [
                "^LWR[0-9][A-Z][0-9][0-9]$",  # LWR a MMM
                "^M[A-M]{2}[0-9][A-Z][0-9][0-9]$",
                "^RXK[0-9][A-Z][0-9][0-9]$",  # RXK a RYI
                "^R[X-Y][A-I][0-9][A-Z][0-9][0-9]$",
                "^RKW[0-9][A-Z][0-9][0-9]$",  # RKW a RLP
                "^RL[A-P][0-9][A-Z][0-9][0-9]$",
                "^RDS[0-9][A-Z][0-9][0-9]$",  # RDS a REB
                "^RE[A-B][0-9][A-Z][0-9][0-9]$",
                "^RAA[0-9][A-Z][0-9][0-9]$",  # RAA a RAJ
                "^RA[B-J][0-9][A-Z][0-9][0-9]$",
                "^QTK[0-9][A-Z][0-9][0-9]$",  # QTK a QTM
                "^QTM[0-9][A-Z][0-9][0-9]$",
                "^QHA[0-9][A-Z][0-9][0-9]$",  # QHA a QJZ
                "^QJ[A-Z][0-9][A-Z][0-9][0-9]$",
                "^OKD[0-9][A-Z][0-9][0-9]$",  # OKD a OKH
                "^OKH[0-9][A-Z][0-9][0-9]$"
            ]
            self.matches = any(re.match(regex, placa) for regex in self.regexes)

    # Instanciando as classes e verificando se a placa corresponde a algum regex
    pr = PR(placa)
    rs = RS(placa)
    sc = SC(placa)

    padrao = re.compile(r'^[A-Z]{3}[0-9][A-Z][0-9]{2}$')

    if not padrao.match(placa):
        return "Formato de placa inválida"
    # Retornando o estado correspondente ou uma mensagem padrão
    elif pr.matches:
        return "A placa " + placa + " pertence ao estado do Paraná"
    elif rs.matches:
        return "A placa " + placa + " pertence ao estado do Rio Grande do Sul"
    elif sc.matches:
        return "A placa " + placa + " pertence ao estado de Santa Catarina"
    else:
        return "A placa não pertence ao estado do Paraná, Rio Grande do Sul ou Santa Catarina"

def calculate_combinations(start, end):
    
    # Convertendo cada caractere em valor numérico ajustado ('A' -> 0, ..., 'Z' -> 25)
    def sequence_value(seq):
        return (ord(seq[0]) - ord('A')) * 26**2 + (ord(seq[1]) - ord('A')) * 26 + (ord(seq[2]) - ord('A'))

    start_val = sequence_value(start)
    end_val = sequence_value(end)
    
    #print("Há " + str((end_val - start_val + 1)) + " placas entre " + start + " e " + end)
    
    # Será calculado o número de placas entre o intervalo, por exemplo entre AAA e BEZ há 806 combinações de letras
    # Se soma +1 para incluir ambas as extremidades do intervalo.
    
    # Calculando o número de combinações entre as sequências de letras
    # O número de combinações totais de letras + as outras possíveis combinações de números e letras da placa
    return (end_val - start_val + 1) * 10 * 26 * 10 * 10  # Multiplicando pelas combinações numéricas

# Calculando as combinações para cada estado
pr_combinations = calculate_combinations('AAA', 'BEZ') + calculate_combinations('RHA', 'RHZ')
rs_combinations = calculate_combinations('IAQ', 'JDO')
sc_combinations = (
    calculate_combinations('LWR', 'MMM') + 
    calculate_combinations('RXK', 'RYI') + 
    calculate_combinations('RKW', 'RLP') + 
    calculate_combinations('RDS', 'REB') + 
    calculate_combinations('RAA', 'RAJ') + 
    calculate_combinations('QTK', 'QTM') + 
    calculate_combinations('QHA', 'QJZ') + 
    calculate_combinations('OKD', 'OKH')
)


while True:
    
    print("Padrão Mercosul: L L L Nº L Nº Nº")
    placa = input("Placa para consulta: ")
    estado = estados(placa)

    print("\n" + estado)

    print(f"\nTotal de placas disponíveis para o Paraná: {pr_combinations}")
    print(f"Total de placas disponíveis para o Rio Grande do Sul: {rs_combinations}")
    print(f"Total de placas disponíveis para Santa Catarina: {sc_combinations}\n")
