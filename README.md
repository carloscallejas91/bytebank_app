
# Bytebank 🏦

Um aplicativo moderno de gerenciamento de finanças construído com Flutter e Firebase, focado em uma arquitetura limpa, escalável e reativa.


## ✨ Funcionalidades

- [x] **Autenticação de Usuários Completa**
- [x] Criar Conta com nome, e-mail e senha.
- [x] Login com e-mail e senha.
- [x] Recuperação de Senha via e-mail.
- [x] Logout seguro.
- [x] Gerenciamento de sessão (login automático ao reiniciar o app).
- [x] **Dashboard Dinâmico e Reativo**
- [x] Header personalizado com nome e avatar do usuário.
- [x] Saldo total da conta atualizado em tempo real.
- [x] Resumo de Entradas e Saídas mensais.
- [x] Filtro interativo por mês e ano.
- [x] Gráfico de gastos mensais agrupados por método de pagamento.
- [x] Gráfico de receitas mensais agrupadas por origem.
- [x] **Gerenciamento de Transações (CRUD)**
- [x] Adicionar novas transações (Entradas e Saídas) através de um BottomSheet.
- [x] Listar todas as transações em tempo real, ordenadas por data.
- [x] Editar uma transação existente.
- [x] Deletar uma transação com diálogo de confirmação.
- [x] **Gerenciamento de Perfil**
- [x] Avatar padrão para novos usuários.
- [x] Funcionalidade para alterar o avatar usando a câmera ou galeria.
- [x] Persistência do avatar localmente no cache do dispositivo.

## 🚀 Arquitetura e Tecnologias

Este projeto foi construído seguindo princípios de arquitetura limpa e separação de responsabilidades.

-   **Linguagem:** Dart
-   **Framework:** Flutter
-   **Gerenciamento de Estado e Injeção de Dependência:** GetX
-   **Backend:** Firebase (Authentication, Cloud Firestore)
-   **Padrão Arquitetural:** Modular (feature-driven) com separação em Camadas (UI -> Controller -> Service).
-   **Principais Pacotes:**
-   `get`: Para todo o gerenciamento de estado, rotas e DI.  
    -   `firebase_core`, `firebase_auth`, `cloud_firestore`: Integração com o backend.  
    -   `image_picker`, `path_provider`, `shared_preferences`: Para seleção e cache de avatar.  
    -   `flutter_masked_text2`: Máscaras de input (ex: moeda).  
    -   `month_picker_dialog`: Seletor de mês/ano para o filtro.  
    -   `intl`: Formatação de datas e moedas.

## ⚙️ Começando

Siga os passos abaixo para configurar e rodar o projeto localmente.

### Pré-requisitos

- Você precisa ter o [Flutter 3.35.2](https://docs.flutter.dev/install/archive) instalado e configurado na sua máquina.

### 1. Configuração do Projeto Local

1. Clone este repositório:  
   ``git clone https://github.com/carloscallejas91/bytebank_app.git``
2. Instale as dependências:  
   ``flutter pub get``
3. Execute o aplicativo:  
   ``flutter run``
## 📂 Estrutura de Pastas

O projeto segue uma estrutura modular para manter o código organizado e desacoplado.

```  
lib/  
├── app/  
│   ├── bindings/     # Bindings globais (AppBinding)  
│   ├── data/         # Enums e Models  
│   ├── routes/       # Definição de rotas (AppPages, AppRoutes)  
│   ├── services/     # Lógica de negócio e comunicação com APIs (AuthService, DatabaseService)  
│   ├── ui/           # Widgets, Temas e componentes de UI globais  
│   └── utils/        # Classes utilitárias (DateFormatter, Validators)  
│  
├── modules/          # Cada funcionalidade do app tem seu próprio módulo  
│   ├── auth/         # Tela e controller de Login  
│   ├── create/       # Tela e controller para criação de conta  
│   ├── dashboard/    # Tela e controller do Dashboard  
│   ├── forget/       # Tela e controller do para recuperação de senha  
│   ├── home/         # A "casca" principal do app após o login (Encapsula Dashboard e Transaction)  
│   ├── splash/       # Tela de gerenciamento após login ou logout automático  
│   ├── transaction/  # Tela e controller da lista de transações  
│  
└── main.dart         # Ponto de entrada da aplicação  
```