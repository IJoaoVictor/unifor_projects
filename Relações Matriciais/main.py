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

#Itens Restantes

# - Verificar se a matriz é reflexiva

def isReflexive(matrix):

# Itera sobre os elementos da diagonal principal
  
  for i in range(len(matrix)):
      if matrix[i][i] != 1:
        print("\nA matriz não é reflexiva")
        return False

  print("\nA matriz é reflexiva")
  return True
  
# - Verificar se a matriz é simétrica

def isSymmetric(matrix):

  # Verifica se a matriz é igual à sua transposta
  for i in range(len(matrix)):
      for j in range(len(matrix[0])):
          if matrix[i][j] != matrix[j][i]:
            print("\nA matriz não é simétrica")
            return False

  print("\nA matriz é simétrica")
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
# - Verificar se a matriz é transitiva
# - Identificar se a Relação é de Ordem, se é de Equivalência e, caso existam, quem são os elementos maximais e minimais, e o maior e menor elemento da relação.
# - Identificar e completar fecho
adjacencyMatrix = construir_matriz_adjacencia(estacoes, linhas_por_estacao)

busMatrix = [
  [0,1,0,0,0,1],
  [1,0,0,1,0,0],
  [0,0,0,1,0,0],
  [0,1,1,0,0,1],
  [0,0,0,0,0,1],
  [1,0,0,1,1,0]
]

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

# Imprimir a matriz de adjacência
printMatrix(adjacencyMatrix)

print("\nMatrix Composta\n")
compositionMatrix = multiMatrix(busMatrix, adjacencyMatrix);
printMatrix(compositionMatrix)

print("\nMatrix Transposta\n")
transposeMatrix = transposeMatrix(adjacencyMatrix);
printMatrix(transposeMatrix)


isReflexive(reflexiva)
isSymmetric(simetrica)
isAssymmetric(assimetrica)
