'''
A função gerar_tabela_vigenere cria a tabela de Vigenère.

A tabela é uma matriz onde cada linha é o alfabeto deslocado ciclicamente.
Para cada letra do alfabeto, deslocamos as letras subsequentes e as concatenamos com as letras anteriores, criando assim uma linha da tabela.

A tabela é armazenada em tabela_vigenere.

-------------------------------------------------------------------------------------------

A função encontrar_chave descobre a chave usada na cifra de Vigenère.
Iteramos sobre cada letra do texto original e sua correspondente no texto cifrado usando um índice i.

Para cada par de letras (letra_original e letra_cifrada):
  Encontramos o índice da letra original (letra_original) no alfabeto.
  Usamos esse índice para encontrar a linha correspondente na tabela de Vigenère.
  Encontramos a coluna onde a letra cifrada (letra_cifrada) aparece nessa linha.
  A letra correspondente na coluna é parte da chave.

A chave é construída como uma lista de letras e, ao final, convertida para uma string.

-------------------------------------------------------------------------------------------

A função cifrar_mensagem cifra uma mensagem usando a chave.
A chave é repetida para cobrir todo o comprimento da mensagem (chave_repetida).
Iteramos sobre cada letra da mensagem e sua correspondente na chave repetida usando um índice i.

Para cada par de letras (letra_mensagem e letra_chave):
  Encontramos a linha correspondente à letra da chave.
  Encontramos a coluna correspondente à letra da mensagem.
  A letra cifrada é a interseção dessa linha e coluna na tabela de Vigenère.
  Se a letra não estiver no alfabeto (como espaços ou pontuação), ela é adicionada sem modificação.

A mensagem cifrada é construída como uma lista de letras e, ao final, convertida para uma string.

---------------------------------------------------------------------------------------------
A função decifrar_mensagem decifra uma mensagem cifrada usando a chave.

A chave é repetida para cobrir todo o comprimento da mensagem cifrada (chave_repetida).
Iteramos sobre cada letra da mensagem cifrada e sua correspondente na chave repetida usando um índice i.

Para cada par de letras (letra_cifrada e letra_chave):
  Encontramos a linha correspondente à letra da chave.
  Encontramos a coluna onde a letra cifrada aparece nessa linha.
  A letra original é a interseção dessa coluna na linha do alfabeto.
  Se a letra não estiver no alfabeto, ela é adicionada sem modificação.

A mensagem decifrada é construída como uma lista de letras e, ao final, convertida para uma string.
'''