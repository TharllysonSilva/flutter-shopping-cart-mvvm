# 🛒 flutter-shopping-cart-mvvm

Implementação de um fluxo completo de compra em Flutter utilizando **MVVM**, com separação explícita entre domínio, infraestrutura e apresentação, aplicação dos padrões **Command/Result**, gerenciamento de estado via **ChangeNotifier**, rotas nomeadas e estado global desacoplado de serviços externos.

O projeto foi desenvolvido com foco em clareza arquitetural, consistência de responsabilidades e aderência aos requisitos técnicos do desafio.

---

# 🎯 Objetivo Arquitetural

Garantir:

- Fonte única de verdade para o carrinho
- Desacoplamento entre domínio e infraestrutura
- Tratamento explícito de estados assíncronos
- Separação clara entre Model, View e ViewModel
- Isolamento de regras de negócio na camada apropriada
- Evolução incremental via commits por feature

---

# 🏗 Arquitetura

## Visão Geral
lib/
├── core/
│ ├── result/
│ ├── command/
│ └── exceptions/
│
├── domain/
│ └── entities/
│
├── data/
│ ├── dto/
│ ├── mappers/
│ └── services/
│
├── store/
│
├── presentation/
│ ├── products/
│ ├── cart/
│ └── checkout/

---

## 1️⃣ Domain (Model)

Contém apenas entidades puras:

- `Product`
- `Cart`
- `CartItem`
- `OrderSummary`

Características:

- Sem dependência de Flutter
- Sem dependência de HTTP
- Sem serialização
- Contém apenas estado e cálculos derivados

Exemplo:
- `Cart.subtotal`
- `Cart.totalItems`
- `OrderSummary.total`

O domínio não conhece infraestrutura.

---

## 2️⃣ Data Layer

Responsável por integração externa e transformação de dados.

### APIs

- `ProductsApi` → HTTP real (`https://fakestoreapi.com/products`)
- `CartApi` → simulação com `Future.delayed`
- `CheckoutApi` → simulação com `Future.delayed`

Todas as operações de carrinho passam por API simulada conforme requisito do desafio.

### DTO + Mapper

- DTOs isolados da entidade
- Mapeamento explícito DTO → Entity
- Evita vazamento de estrutura externa para o domínio

---

## 3️⃣ Store (Fonte Única de Verdade)

`CartStore`

Responsabilidades:

- Manter estado global do carrinho
- Expor snapshot atual (`Cart`)
- Aplicar regras de negócio
- Persistir estado em memória
- Guardar último pedido finalizado

Importante:

- A Store não conhece API
- Não executa operações assíncronas
- Apenas recebe estado validado pelo ViewModel

Regras implementadas:

- Máximo de 10 produtos diferentes
- Carrinho finalizado não pode ser editado
- Validação antes de operações

---

## 4️⃣ ViewModel

Responsável por:

- Orquestrar chamadas de API
- Validar regras antes da execução
- Atualizar Store após sucesso
- Expor estados assíncronos via `Command<T>`

Exemplo:

- `CartViewModel`
- `CheckoutViewModel`
- `ProductsViewModel`

O ViewModel não contém lógica de UI.

---

## 5️⃣ View

Responsável apenas por:

- Renderização
- Reatividade
- Escuta de `ChangeNotifier`
- Exibição de loading e erro

Sem regras de negócio.
Sem chamadas diretas à API.

---

# 🔁 Padrões Arquiteturais

## Command Pattern

Encapsula execução assíncrona.

Permite à View reagir a:

- `isExecuting`
- `result`

Evita lógica imperativa dispersa na UI.

---

## Result Pattern

Representa fluxo explícito de sucesso ou falha:

- `Success<T>`
- `Failure<T>`

Evita exceções como controle de fluxo.

---

# 🌐 Integração Externa

## API Real

- https://fakestoreapi.com/products

Utilizada exclusivamente para catálogo.

## APIs Simuladas

- CartApi
- CheckoutApi

Simulam latência e erro randômico para validar fluxo de erro e loading.

---

# 🚦 Fluxo de Compra

1. Produtos são carregados via HTTP real
2. Usuário adiciona produto
3. View chama ViewModel
4. ViewModel chama CartApi
5. CartApi retorna `Result`
6. ViewModel atualiza Store
7. Store notifica View
8. Checkout chama CheckoutApi
9. Em sucesso:
   - Store marca carrinho como finalizado
   - Navegação limpa stack
10. Novo pedido reseta estado global

---

# 🧠 Decisões Arquiteturais

### 1️⃣ Store não depende de API

Evita acoplamento circular e mantém fonte única de verdade.

### 2️⃣ APIs não conhecem Store

Mantém separação entre infraestrutura e estado.

### 3️⃣ DTO isolado do domínio

Protege domínio de mudanças externas.

### 4️⃣ ViewModels são orquestradores

Garantem que:

- Regras sejam aplicadas antes de execução
- Store só receba estado válido

---

# 📌 Aderência ao Desafio

✔ MVVM com responsabilidades claras  
✔ ChangeNotifier  
✔ Command/Result  
✔ Rotas nomeadas  
✔ Não permite voltar após checkout  
✔ Estado global do carrinho  
✔ Regras de negócio implementadas  
✔ Simulação de API conforme especificado  
✔ Commits organizados por feature  

---

# 🧪 Extensibilidade

Arquitetura preparada para:

- Introdução de UseCases
- Persistência local (Hive/Drift)
- Testes unitários de domínio
- Testes de ViewModel
- Internacionalização
- Modularização futura

---

# 📦 Requisitos

- Flutter 3.x
- Dart 3.x
- provider
- http

---

# ▶ Execução

```bash
flutter pub get
flutter run