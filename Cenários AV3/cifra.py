import string  # Importa a biblioteca string para acessar os caracteres do alfabeto

# Alfabeto em português (26 letras maiúsculas)
alfabeto = string.ascii_uppercase  # Cria uma string contendo as letras maiúsculas do alfabeto

def gerar_tabela_vigenere():
    tabela = []
    # Cria a tabela de Vigenère preenchendo cada linha com uma sequência de letras do alfabeto
    for i in range(len(alfabeto)):
        linha = alfabeto[i:] + alfabeto[:i]
        tabela.append(linha)
    return tabela

tabela_vigenere = gerar_tabela_vigenere()

def encontrar_chave(texto_original, texto_cifrado):
    chave = []  # Lista para armazenar a chave encontrada
    incrementos = []  # Lista para armazenar os incrementos
    # Itera sobre cada letra do texto original e seu correspondente no texto cifrado
    for i in range(len(texto_original)):
        letra_original = texto_original[i].upper()
        letra_cifrada = texto_cifrado[i].upper()
        # Verifica se as letras estão no alfabeto
        if letra_original in alfabeto and letra_cifrada in alfabeto:
            # Calcula o incremento entre as letras original e cifrada
            idx_original = alfabeto.index(letra_original)
            idx_cifrada = alfabeto.index(letra_cifrada)
            incremento = (idx_cifrada - idx_original) % len(alfabeto)
            chave.append(alfabeto[incremento])  # Adiciona a letra correspondente da chave
            incrementos.append(incremento)  # Adiciona o incremento à lista
    return ''.join(chave), incrementos  # Retorna a chave como string e os incrementos como lista

def cifrar_mensagem(mensagem, chave):
    mensagem_cifrada = []  # Lista para armazenar a mensagem cifrada
    chave_repetida = (chave * (len(mensagem) // len(chave))) + chave[:len(mensagem) % len(chave)]
    # Itera sobre cada letra da mensagem e sua correspondente na chave repetida
    for i in range(len(mensagem)):
        letra_mensagem = mensagem[i].upper()
        letra_chave = chave_repetida[i].upper()
        # Verifica se a letra da mensagem está no alfabeto
        if letra_mensagem in alfabeto:
            # Encontra a linha e coluna na tabela de Vigenère
            row = alfabeto.index(letra_chave)
            col = alfabeto.index(letra_mensagem)
            mensagem_cifrada.append(tabela_vigenere[row][col])  # Adiciona a letra cifrada
        else:
            mensagem_cifrada.append(letra_mensagem)  # Adiciona a letra sem modificação
    return ''.join(mensagem_cifrada)  # Retorna a mensagem cifrada como string

def decifrar_mensagem(mensagem_cifrada, chave):
    mensagem_decifrada = []  # Lista para armazenar a mensagem decifrada
    chave_repetida = (chave * (len(mensagem_cifrada) // len(chave))) + chave[:len(mensagem_cifrada) % len(chave)]
    # Itera sobre cada letra da mensagem cifrada e sua correspondente na chave repetida
    for i in range(len(mensagem_cifrada)):
        letra_cifrada = mensagem_cifrada[i].upper()
        letra_chave = chave_repetida[i].upper()
        # Verifica se a letra cifrada está no alfabeto
        if letra_cifrada in alfabeto:
            # Encontra a linha e coluna na tabela de Vigenère
            row = alfabeto.index(letra_chave)
            col = tabela_vigenere[row].index(letra_cifrada)
            mensagem_decifrada.append(alfabeto[col])  # Adiciona a letra decifrada
        else:
            mensagem_decifrada.append(letra_cifrada)  # Adiciona a letra sem modificação
    return ''.join(mensagem_decifrada)  # Retorna a mensagem decifrada como string

# Mensagem original e cifrada para criptoanálise
texto_original = "ABCD"
texto_cifrado = "LOPE"

# Criptoanálise para descobrir a chave e os incrementos
chave, incrementos = encontrar_chave(texto_original, texto_cifrado)
print(f"Chave descoberta: {chave}")
print(f"Incrementos: {incrementos}")

# Encriptar uma nova mensagem
nova_mensagem = "PROJETO"
mensagem_cifrada = cifrar_mensagem(nova_mensagem, chave)
print(f"Mensagem cifrada: {mensagem_cifrada}")

# Decriptar a mensagem cifrada
mensagem_decifrada = decifrar_mensagem(mensagem_cifrada, chave)
print(f"Mensagem decifrada: {mensagem_decifrada}")
