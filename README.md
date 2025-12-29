
# Bytebank 🏦

Um aplicativo moderno de gerenciamento de finanças construído com **Flutter**, focado em **Clean Architecture**, **Modularização** e **Alta Performance** (Fase 04).

## ✨ Funcionalidades

### 🔐 Autenticação e Segurança
- [x] **Login/Cadastro**: E-mail e senha com validação robusta.
- [x] **Recuperação de Senha**: Fluxo completo via Firebase Auth.
- [x] **Sessão Persistente**: Login automático e gerenciamento de estado de usuário (`userChanges`).
- [x] **Logout Seguro**: Encerramento limpo de sessão e subscriptions.

### 📊 Dashboard Inteligente
- [x] **Resumo Financeiro**: Saldo total, receitas e despesas do mês selecionado.
- [x] **Busca Precisa**: Cálculo de resumos baseado no dataset mensal completo (Data Layer), não apenas na lista visível.
- [x] **Filtros Temporais**: Navegação entre meses com atualização reativa.
- [x] **Performance**: Dados cacheados para visualização instantânea (Offline-First).
- [x] **Gráficos e Categorias**: Visualização detalhada de gastos por categoria.

### 💸 Gestão de Transações
- [x] **CRUD Completo**: Criar, Ler, Atualizar e Deletar transações.
- [x] **Lista Infinita**: Paginação eficiente (Lazy Loading) para grandes volumes de dados.
- [x] **Filtros Avançados**: Busca por texto, tipo (Receita/Despesa) e ordenação.
- [x] **Comprovantes**: Upload e visualização de comprovantes (Firebase Storage).
- [x] **Cache Mensal**: Sistema de cache específico para garantir performance no cálculo de saldos.

### 👤 Perfil
- [x] **Avatar**: Personalização de foto de perfil (Câmera/Galeria) com persistência local.

---

## 🚀 Arquitetura e Tecnologias

Este projeto atingiu o nível de maturidade da **Fase 04**, implementando padrões rigorosos de engenharia de software.

-   **Linguagem:** Dart 3+
-   **Framework:** Flutter
-   **State Management:** GetX (Reatividade granular com `.obs` e `Obx`).
-   **Arquitetura:** Clean Architecture (Camadas bem definidas).
-   **Backend:** Firebase (Auth, Firestore, Storage).

### Estrutura de Camadas (Clean Architecture)

1.  **Domain (`lib/domain`)**: O coração do projeto.
    -   Contém Entidades (`TransactionEntity`), UseCases (`GetMonthlyTransactionsUseCase`) e Contratos de Repositório (`ITransactionRepository`).
    -   Totalmente desacoplado de frameworks externos.
2.  **Data (`lib/data`)**: Implementação técnica.
    -   Repositórios (`FirebaseDataRepositoryImpl`), DataSources (`FirebaseDataSource`, `LocalDataSource`) e Models/DTOs.
    -   Gerencia a estratégia de cache (Network-first, Cache-fallback).
3.  **Presentation (`lib/modules`)**: Interação com o usuário.
    -   Controllers, Screens e Widgets. Depende apenas do Domínio e serviços injetados.

---

## ⚡ Performance e Otimização

-   **Lazy Loading**: Módulos e Controllers são carregados sob demanda via Sistema de Rotas do GetX, economizando memória.
-   **Caching Inteligente**: Implementação de cache local (`GetStorage`) para transações e dados de usuário, permitindo funcionamento offline parcial.
-   **Reatividade**: A interface reage a streams de dados, evitando reconstruções desnecessárias (`setState`).

---

## 📂 Estrutura de Pastas

```
lib/
├── app/
│   ├── bindings/     # Injeção de dependência global
│   ├── constants/    # Constantes globais
│   ├── routes/       # Mapa de rotas do App
│   ├── services/     # Serviços globais
│   ├── ui/           # Temas e Widgets compartilhados
│   └── utils/        # Formatadores e auxiliares
│
├── data/             # Camada de Dados (Clean Arch)
│   ├── datasources/  # Fontes de dados (Firebase, Local)
│   ├── models/       # DTOs e Mappers
│   └── repositories/ # Implementação dos Repositórios
│
├── domain/           # Camada de Domínio (Clean Arch)
│   ├── entities/     # Regras de Negócio Puras
│   ├── enums/        # Enumerações
│   ├── repositories/ # Interfaces (Contratos)
│   └── usecases/     # Casos de Uso (Lógica da Aplicação)
│
├── modules/          # Funcionalidades (Presentation Layer)
│   ├── auth/         # Login
│   ├── create/       # Cadastro
│   ├── dashboard/    # Resumos e Gráficos
│   ├── forgot/       # Recuperação de Senha
│   ├── home/         # Container Principal
│   ├── redirect/     # Redirecionamento
│   ├── transaction/  # Listagem e Filtros
│
└── main.dart         # Entry Point
```

---

## ⚙️ Configuração para Desenvolvimento

### Pré-requisitos
-   Flutter SDK Instalado.
-   Dispositivo Android/iOS ou Emulador.

### Passos
1.  **Clone o repositório**:
    ```bash
    git clone https://github.com/carloscallejas91/bytebank_app.git
    ```
2.  **Instale as dependências**:
    ```bash
    flutter pub get
    ```
3.  **Configuração do Firebase**:
    -   Se for avaliador: Cole o `google-services.json` fornecido em `android/app/`.
    -   Se for desenvolvedor: Use o `flutterfire configure` para vincular ao seu projeto.
4.  **Execute o App**:
    ```bash
    flutter run
    ```