# Construção da matriz de adjacência das estações e suas linhas
# Cada linha representa uma estação e cada coluna representa uma linha

# Precisa estar na ordem correta

# Lista de estações
estacoes = ["Terminal", "Shopping", "Parque", "Praça", "Centro", "Avenida"]

# Dicionário para mapear as linhas de cada estação

linhas_por_estacao = {
  
    "Terminal": ["Shopping"],
    "Shopping": ["Terminal"],
    "Parque":   ["Shopping", "Praça"],
    "Praça":    ["Parque"],
    "Centro":   ["Praça", "Avenida"],
    "Avenida":  ["Centro"]
}

# Função para construir a matriz de adjacência
def construir_matriz_adjacencia(estacoes, linhas_por_estacao):
    
    matriz_adjacencia = []
    
    for estacao_origem in estacoes:
      
      linha_adjacencia = []
      
      for estacao_destino in estacoes:
            
        if estacao_destino in linhas_por_estacao[estacao_origem]:        
          linha_adjacencia.append(1)  # Há uma conexão entre as estações
            
        else:
          linha_adjacencia.append(0)  # Não há conexão entre as estações
        
      matriz_adjacencia.append(linha_adjacencia)

    print("Matriz de Adjacência\n")
    return matriz_adjacencia

# Função para exibir a matriz 

def printMatrix(matriz):
  
  # len(matriz) = número de linhas
  # len(matriz[linha]) = número de colunas
  
  for linha in range(len(matriz)):
    for coluna in range(len(matriz[linha])):
      print(matriz[linha][coluna], end='  ')
    print()


# Função para exibir a matriz de adjacência

def transposeMatrix(matriz):

  # len(matriz) = número de linhas
  # len(matriz[0]) = número de colunas
  
  T = [None] * len(matriz)

  for linha in range(len(T)):
    T[linha] = [None]*len(matriz[0])

  for linha in range(len(T)):
    for coluna in range(len(T[linha])):
      T[linha][coluna] = matriz[coluna][linha]

  return T

# Composição da relação das linhas de metrô com a relação das linhas de ônibus
# A composição das matrizes A e B se dará pela multiplicação das matrizes B e A

def multiMatrix(matrizA, matrizB):
  
  # len(matriz) = número de linhas
  # len(matriz[0]) = número de colunas
  
  if (len(matrizA[0]) == len(matrizB)):
    
    Y = [None] * len(matrizA)
    
    for linha in range(len(Y)):
      Y[linha] = [None]*len(matrizB[0])
      
      for coluna in range(len(Y[0])):
        Y[linha][coluna] = 0
        
        for k in range(len(matrizA[0])):
          Y[linha][coluna] = Y[linha][coluna] + (matrizA[linha][k]*matrizB[k][coluna])


    return Y
  
  else:
    print("\nOrdens de matrizes não casam para produto matricial")

#Itens

# - Verificar se a matriz é reflexiva

def isReflexive(matrix):

# Itera sobre os elementos da diagonal principal
  
  for i in range(len(matrix)):
      if matrix[i][i] != 1:
        print("A matriz não é reflexiva")
        return False

  print("A matriz é reflexiva")
  return True
  
# - Verificar se a matriz é simétrica

def isSymmetric(matrix):

  # Verifica se a matriz é igual à sua transposta
  for i in range(len(matrix)):
      for j in range(len(matrix[0])):
          if matrix[i][j] != matrix[j][i]:
            print("A matriz não é simétrica")
            return False

  print("A matriz é simétrica")
  return True

# - Verificar se a matriz é assimétrica
    
def isAssymmetric(matrix):

  # Verificar se a diagonal principal é toda 0
  
  for i in range(len(matrix)):
      if matrix[i][i] != 0:
        print('A matriz não é assimétrica')
        return False

  # Verificar se a matriz satisfaz a condição matrix[i][j] == 1 -> matrix[j][i] == 0
  
  for i in range(len(matrix)):
      for j in range(len(matrix[0])):
          if matrix[i][j] == 1 and matrix[j][i] != 0:
            print('A matriz não é assimétrica')
            return False

  print('A matriz é assimétrica')
  return True
             
# - Verificar se a matriz é antissimétrica
def isAntisymmetric(matriz):
  
  # - Verificar se a matriz é antissimétrica
  for i in range(len(matriz)):
    for j in range(len(matriz[0])):
      if matriz[i][j] == 1 and matriz[j][i] == 1 and i != j:
        print('A matriz não é antissimétrica')
        return False

  print('A matriz é antissimétrica')
  return True

# - Verificar se a matriz é transitiva
def isTransitive(matriz):
  # - Verificar se a matriz é transitiva
  for i in range(len(matriz)):
    for j in range(len(matriz[0])):
      if matriz[i][j] == 1:
        for k in range(len(matriz[0])):
          if matriz[j][k] == 1 and matriz[i][k] !=1:
            print('A matriz não é transitiva')
            return False
  
  print('A matriz é transitiva')
  return True
  
# - Ientificar se a Relação é de Ordem, se é de Equivalência e, caso existam, quem são os elementos maximais e minimais, e o maior e menor elemento da relação.

def isOrderRelation(matrix):

  if isReflexive(matrix) and isAntisymmetric(matrix) and isTransitive(matrix):
    print('A matriz representa uma relação de ordem')
    return True
  else:
    print('A matriz não representa uma relação de ordem')
    return False

def isEquivalenceRelation(matrix):
  if isReflexive(matrix) and isSymmetric(matrix) and isTransitive(matrix):
    print('A matriz representa uma relação de equivalência')
    return True
  else:
    print('A matriz não representa uma relação de equivalência')
    return False
    
def maximals_minimals(matrix):

  maximais = []
  minimais = []
  
  for i in range(len(matrix)):
    
      isMaximal = True
      isMinimal = True
  
      for j in range(len(matrix[0])):
          if matrix[i][j] == 1 and i != j:  # Verifica se há uma relação de i para j
              isMaximal = False
          if matrix[j][i] == 1 and i != j:  # Verifica se há uma relação de j para i
              isMinimal = False
  
      if isMaximal:
          maximais.append(i+1)
      if isMinimal:
          minimais.append(i+1)

  if maximais != []:
    print("Elementos maximais:", maximais)
  else:
    print("Não há elementos maximais")

  if minimais != []: #Acusa erro mesmo
    print("Elementos minimais:", minimais) 
  else:
    print("Não há elementos minimais")

def findLargestElement(matrix):
  
  linePosition = 0
  # Verifica a linha que possui apenas 1
  for row in matrix:
      isMaxLine = True
      for element in row:
          if element != 1:
              isMaxLine = False
              break
      if isMaxLine:
          return linePosition
      linePosition += 1
    
  return None  # Retorna None se não encontrar nenhuma linha de 1s

def findSmallestElement(matrix):

  #Analisa a linha que possui apenas 1 da transposta, que é a coluna da original
  transposedMatrix = transposeMatrix(matrix)
  return findLargestElement(transposedMatrix)

#Chama as duas funções anteriores

def callElementsFinder(matrix):
  
  if findLargestElement(matrix) is not None:
    print("O maior elemento é:", findLargestElement(matrix) + 1) 
  else:
    print("Não há maior elemento")

  if findSmallestElement(matrix) is not None: #Acusa erro mesmo
    print("O menor elemento é:", findSmallestElement(matrix) + 1)
  else:
    print("Não há menor elemento")


# Fecho Simétrico

adjacencyMatrix = construir_matriz_adjacencia(estacoes, linhas_por_estacao)
printMatrix(adjacencyMatrix)

busMatrix = [
  [0,1,0,0,0,1],
  [1,0,0,1,0,0],
  [0,0,0,1,0,0],
  [0,1,1,0,0,1],
  [0,0,0,0,0,1],
  [1,0,0,1,1,0]
]

# Composição das Matrizes

print('\nMatriz Composta\n')
printMatrix(multiMatrix(busMatrix, adjacencyMatrix))


reflexiva = [
  [1,1,0],
  [1,1,1],
  [0,0,1]
]

simetrica = [
  [1,1,0],
  [1,1,1],
  [0,1,0]
]

assimetrica = [
  [0,1,0],
  [0,0,0],
  [0,1,0]
]

antisimetrica = [
  [1,1,0],
  [0,1,0],
  [0,1,0]
]

transitiva = [
  [0,1,0],
  [0,0,0],
  [0,1,0]
]

minimals_maximals = [
  [1,1,1],
  [0,1,0], #maximal = 2 e 3 e minimal = 1
  [0,0,1]  #maior = 1 e menor = não tem
]

#isReflexive(reflexiva)
#isSymmetric(simetrica)
#isAssymmetric(assimetrica)
#isAntisymmetric(antisimetrica)
#isTransitive(transitiva)
#isOrderRelation(minimals_maximals)
#isEquivalenceRelation(minimals_maximals)

maximals_minimals(minimals_maximals)
callElementsFinder(minimals_maximals)
