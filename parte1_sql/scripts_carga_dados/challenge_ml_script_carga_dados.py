# -*- coding: utf-8 -*-
"""challeng_ml_script_carga_dados.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1YkqdRJd_FJb7cOvWbrmpml3H9K5b36TV

Gerando lista fictícia de vendas para carga da tabela Order
"""

import random
from datetime import datetime, timedelta

# Lista de customerIDs de 11 a 15
customer_ids = list(range(11, 16))

# Gera mil linhas de dados ficticios
orders = []
start_date = datetime(2023, 1, 1)
end_date = datetime(2023, 12, 31)

for _ in range(1000):
    customer_id = random.choice(customer_ids) # Seleciona um customerID
    fecha_order = start_date + timedelta(days=random.randint(0, (end_date - start_date).days)) # Gera uma data aleatoria
    orders.append((customer_id, fecha_order.strftime('%Y-%m-%d'))) # Monta os valores gerados

# Imprime os dados gerados
for order in orders:
    print(order)

"""Gerando lista fictícia de itens de pedidos para carga da tabela OrderItem"""

import random

# Definir os valores para preço unitário com base no itemId
preco_unitario_por_item = {
    1: 799.99,
    2: 59.99,
    3: 99.99,
    6: 499.99,
    7: 29999.99
}

# Lista de itemIDs (excluindo 4 e 5)
item_ids = [item_id for item_id in range(1, 8) if item_id not in [4, 5]]

# Gerar lista fictícia de dados para a tabela OrderItem
order_items = []

# Gera uma venda por item
for order_id in range(501, 1000):  # OrderId varia de 1 a 50
    item_id = random.choice(item_ids)  # Escolha aleatoriamente um item
    cantidad = random.randint(1, 3)  # Quantidade aleatória entre 1 e 3
    preco_unitario = preco_unitario_por_item.get(item_id, 0)  # Obter o preço unitário com base no itemId

    # Adicionar os valores gerados à lista de OrderItem
    order_items.append((order_id, item_id, cantidad, preco_unitario))

# Imprimir os dados gerados
for order_item in order_items:
    print(order_item)

"""Gerando lista ficticia de status de pedidos"""

import random

# Valores possíveis para statusDescripcion
status_descripciones = ["Criado", "Em transito", "Cancelado", "Finalizado"]

# Lista fictícia de dados para a tabela orderStatus
order_status_data = []
start_date = datetime(2023, 1, 1)
end_date = datetime(2023, 12, 31)

for order_id in range(1, 51):  # OrderId varia de 1 a 50
    status_descripcion = random.choice(status_descripciones)  # Escolha aleatoriamente uma descrição de status
    is_default = 1 if status_descripcion == "Criado" else 0  # isDefault é 1 se statusDescricao for "Criado", senão é 0
    is_final = 1 if status_descripcion in ["Cancelado", "Finalizado"] else 0  # isFinal é 1 se statusDescricao for "Cancelado" ou "Finalizado", senão é 0
    fecha_actualizacion = start_date + timedelta(days=random.randint(0, (end_date - start_date).days)) # Selecionando uma data aleatoria

    # Adicionar os valores gerados à lista de orderStatus
    order_status_data.append((order_id, status_descripcion, is_default, is_final, fecha_actualizacion.strftime('%Y-%m-%d')))

# Imprimir os dados gerados
for order_status in order_status_data:
    print(order_status)