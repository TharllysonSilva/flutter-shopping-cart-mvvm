agora coloque todo no mesmo padrão pois uma parte esta diferente da outra : 
# 🛒 flutter-shopping-cart-mvvm

Implementação de um fluxo completo de compra em Flutter utilizando **arquitetura MVVM**, com separação explícita entre domínio, infraestrutura e apresentação, aplicação dos padrões **Command/Result**, gerenciamento de estado via **ChangeNotifier**, navegação com **rotas nomeadas** e estado global desacoplado de serviços externos.

O projeto foi desenvolvido com foco em **clareza arquitetural, previsibilidade de fluxo de dados, isolamento de responsabilidades e aderência aos requisitos técnicos do desafio**.

---

# 🎯 Objetivo Arquitetural

Garantir uma arquitetura previsível e escalável baseada nos seguintes princípios:

- Fonte única de verdade para o carrinho
- Desacoplamento entre domínio e infraestrutura
- Estados assíncronos explícitos
- Separação clara entre Model, View e ViewModel
- Isolamento de regras de negócio
- Fluxo de dados unidirecional
- Evolução incremental via commits por feature

---

# 🏗 Arquitetura

O projeto segue a arquitetura **MVVM recomendada pelo time do Flutter**, com camadas bem definidas e responsabilidades isoladas.

## Estrutura de Pastas

```text
lib/
├── core/
│   ├── command/
│   ├── result/
│   └── exceptions/
│
├── domain/
│   └── entities/
│       ├── product.dart
│       ├── cart.dart
│       ├── cart_item.dart
│       └── order_summary.dart
│
├── data/
│   ├── dto/
│   ├── mappers/
│   └── services/
│       ├── products_api.dart
│       ├── cart_api.dart
│       └── checkout_api.dart
│
├── store/
│   └── cart_store.dart
│
├── presentation/
│   ├── products/
│   │   ├── view/
│   │   └── viewmodel/
│   │
│   ├── cart/
│   │   └── view/
│   │
│   ├── checkout/
│   │   └── view/
│   │
│   ├── widgets/
│   └── routes/
│
└── main.dart

---



Fluxo Arquitetural
View
  │
  ▼
ViewModel
  │
  ▼
Service (API)
  │
  ▼
Result (Success / Failure)
  │
  ▼
Store (CartStore)
  │
  ▼
UI Reactiva

---

# 1️⃣ Domain (Model)

A camada de domínio contém **entidades puras**, independentes de qualquer tecnologia externa.

### Entidades implementadas

- `Product`
- `Cart`
- `CartItem`
- `OrderSummary`

### Características do domínio

- Sem dependência de Flutter
- Sem dependência de HTTP
- Sem serialização
- Contém apenas **estado e regras derivadas**

### Exemplos de lógica no domínio

- `Cart.subtotal`
- `Cart.totalItems`
- `Cart.totalDifferentItems`
- `OrderSummary.total`

O domínio **não conhece infraestrutura**.

---

# 2️⃣ Data Layer

Responsável por **integração externa e transformação de dados**.

## APIs

### ProductsApi

Consumo real da API:


https://fakestoreapi.com/products


Responsável por:

- Requisição HTTP
- Parsing JSON
- Mapeamento DTO → Entity

---

### CartApi

Simulação de operações de carrinho.

Características:

- Latência artificial (`Future.delayed`)
- Falha randômica simulada
- Retorna `Result`

---

### CheckoutApi

Simula finalização do pedido.

Comportamento:

- Delay artificial
- Possibilidade de erro randômico
- Retorno tipado com `Result`

---

# 3️⃣ Store (Fonte Única de Verdade)

O estado global do carrinho é mantido por:


CartStore


### Responsabilidades

- Manter estado global
- Aplicar regras de negócio
- Notificar UI via `ChangeNotifier`
- Persistir estado em memória
- Guardar último pedido finalizado

### Importante

- A Store **não conhece API**
- A Store **não executa operações assíncronas**
- A Store **não contém lógica de UI**

---

# 4️⃣ ViewModel

Os ViewModels atuam como **orquestradores do fluxo da aplicação**.

### Responsabilidades

- Chamar APIs
- Aplicar validações
- Atualizar a Store
- Expor estado assíncrono para a UI

### ViewModels implementados

- `ProductsViewModel`
- `CartViewModel`
- `CheckoutViewModel`

Cada operação assíncrona é encapsulada em um:


Command<T>


---

# 5️⃣ View

A camada de apresentação é responsável apenas por:

- Renderização de UI
- Reatividade
- Navegação
- Exibição de loading e erro

As Views **não contêm regras de negócio**.

---

# 🔁 Padrões Arquiteturais

## Command Pattern

Encapsula operações assíncronas.

Permite à View reagir a:

- `isExecuting`
- `result`

Exemplo:


loadProductsCommand
cartOperationCommand
checkoutCommand


---

## Result Pattern

Representa explicitamente o resultado das operações.

Tipos disponíveis:


Success<T>
Failure<T>


### Benefícios

- Evita uso de exceções para controle de fluxo
- Torna estados explícitos
- Facilita testes

---

# 🛒 Regras de Negócio do Carrinho

Implementadas na **Store**.

### Regras

1. Máximo de **10 produtos diferentes**
2. Carrinho **finalizado não pode ser editado**
3. Operações sempre passam por **CartApi simulada**

---

# 🌐 Integração com API

## API Real


https://fakestoreapi.com/products


Utilizada apenas para:

- Catálogo de produtos

---

## APIs Simuladas

- `CartApi`
- `CheckoutApi`

Simulam:

- Latência
- Erros randômicos
- Operações de backend

---

# 🚦 Fluxo de Compra

1️⃣ Produtos carregados via HTTP  
2️⃣ Usuário adiciona produto ao carrinho  
3️⃣ View chama ViewModel  
4️⃣ ViewModel chama CartApi  
5️⃣ CartApi retorna `Result`  
6️⃣ ViewModel atualiza Store  
7️⃣ Store notifica UI  
8️⃣ Checkout chama CheckoutApi  

9️⃣ Em sucesso:

- Carrinho é finalizado
- Navegação limpa stack

🔟 Novo pedido reinicia estado global

---

# 🧪 Testes

O projeto inclui três tipos de testes.

## Testes Unitários

Validação de regras do domínio.

Exemplo:


cart_store_test.dart


Valida:

- limite de 10 produtos diferentes

---

## Testes de ViewModel

Validação de estados assíncronos.

Exemplo:


products_viewmodel_test.dart


Cenários testados:

- loading
- sucesso
- erro

---

## Testes de Integração

Validação de fluxo de UI.

Exemplo:


products_screen_test.dart


Testa:

- renderização da lista
- navegação para carrinho

---

# 📌 Aderência ao Desafio

✔ Arquitetura MVVM  
✔ Separação clara de camadas  
✔ ChangeNotifier  
✔ Command Pattern  
✔ Result Pattern  
✔ Rotas nomeadas  
✔ Estado global do carrinho  
✔ Regras de negócio aplicadas  
✔ API real para produtos  
✔ APIs simuladas para carrinho e checkout  
✔ Tratamento de erros na UI  
✔ Commits organizados por feature  

---

# 🔧 Extensibilidade

A arquitetura permite evolução para:

- UseCases na camada de domínio
- Persistência local (Hive / Drift)
- Injeção de dependência (GetIt / Riverpod)
- Testes de integração mais robustos
- Internacionalização
- Modularização por feature

---

# 📦 Requisitos


Flutter 3.x
Dart 3.x


### Dependências principais


provider
http
mocktail
flutter_test


---

# ▶ Execução

```bash
flutter pub get
flutter run