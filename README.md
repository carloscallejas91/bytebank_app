
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
- [x] Animações sutis na entrada dos componentes.
- [x] **Gerenciamento de Transações (CRUD)**
- [x] Adicionar novas transações (Entradas e Saídas) através de um BottomSheet.
- [x] Listar todas as transações em tempo real, ordenadas por data.
- [x] Editar uma transação existente.
- [x] Deletar uma transação com diálogo de confirmação.
- [x] Upload de comprovantes para o Firebase Storage.
- [x] Visualizar comprovantes salvos.
- [x] Filtros avançados na lista por tipo (Entrada/Saída) e ordenação (data ascendente/descendente).
- [x] Busca por descrição com debounce para otimização de consultas.
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

### 1. Ambiente de Desenvolvimento

Antes de começar, garanta que você tenha o seguinte instalado:

1.  **Git**: [Instale o Git](https://git-scm.com/downloads).

2.  **Flutter SDK**: O framework principal do projeto.
    -   Siga o guia oficial de instalação para o seu sistema operacional: [Instalar o Flutter](https://docs.flutter.dev/get-started/install).
    -   Este projeto foi desenvolvido utilizando uma versão do Flutter [Flutter 3.35.2](https://docs.flutter.dev/install/archive).

3.  **IDE (Editor de Código)**:
    -   **Visual Studio Code**: Altamente recomendado. Instale as extensões `Dart` e `Flutter` a partir do marketplace.
    -   **Android Studio**: Uma alternativa robusta. Os plugins de Dart e Flutter podem ser instalados através do menu de plugins da IDE.

4.  **Configuração da Plataforma (Android)**:
    -   Mesmo que use o VS Code, você precisará do **Android Studio** para instalar o Android SDK e gerenciar os emuladores.
    -   Após instalar o Android Studio, use o **Device Manager** para criar um emulador Android (recomendamos um com a Play Store integrada).

> ### ⚠️ **Instruções para Avaliação (Tech Challenge 3)**
> O arquivo de configuração `google-services.json` foi enviado em anexo na entrega da atividade. Para rodar o projeto:
>
> 1.  **Copie** o arquivo `google-services.json` que você recebeu.
> 2.  **Cole-o** dentro da pasta `android/app/` do projeto.
>
> Neste caso não é necessário realizar nenhuma configuração adicional do Firebase.

### 2. Opcional: Configuração do Firebase

Se você deseja conectar o aplicativo ao seu próprio projeto Firebase em vez de usar o de demonstração, siga estes passos:

1.  **Crie um Projeto Firebase**: Vá até o [Console do Firebase](https://console.firebase.google.com/) e crie um novo projeto.

2.  **Instale o FlutterFire CLI**: Se ainda não tiver, rode o comando:
    ```bash
    dart pub global activate flutterfire_cli
    ```

3.  **Conecte o Projeto**: Na raiz do seu projeto Flutter clonado, execute o comando de configuração do FlutterFire. Ele irá gerar o arquivo `lib/firebase_options.dart` automaticamente.
    ```bash
    flutterfire configure
    ```
    -   Selecione o projeto Firebase que você criou.
    -   Selecione a plataforma Android. O CLI fará o registro do app para você.

4.  **Ative os Serviços no Console**:
    -   **Authentication**: Na aba "Sign-in method", habilite o provedor "E-mail/senha".
    -   **Firestore Database**: Crie um banco de dados em **modo de produção** na localização `southamerica-east1`.
    -   **Storage**: Crie um bucket de armazenamento, também na localização `southamerica-east1`.

5.  **Configure as Regras de Segurança**:
    -   No **Firestore**, vá para a aba "Regras" e cole as regras de segurança necessárias para as coleções `users` e `transactions`.
        ```json
        rules_version = '2';

		service cloud.firestore {
		  match /databases/{database}/documents {

			// Regra para a coleção 'users'
			match /users/{userId} {
			  allow read, update, delete: if request.auth != null && request.auth.uid == userId;
			  allow create: if request.auth != null;
			}

				// Regra para a coleção 'transactions'
			match /transactions/{transactionId} {
			  allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
			  allow read, update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
			}

		  }
		}
        ```
    -   No **Storage**, vá para a aba "Regras" e cole as regras de segurança para permitir que usuários autenticados salvem arquivos.
        ```json
		service firebase.storage {
		  match /b/{bucket}/o {
			// Permite que usuários logados leiam e escrevam na sua própria pasta de recibos
			match /receipts/{userId}/{allPaths=**} {
			  allow read, write: if request.auth != null && request.auth.uid == userId;
			}
		  }
		}
        ```
6.  **Adicione a Chave SHA-1 (Para Android)**:
    -   Para que o login e outros serviços do Google funcionem em modo de depuração, gere sua chave SHA-1:
        ```bash
        cd android
        ./gradlew signingReport
        ```
    -   Copie a chave `SHA1` da variante `debug` e adicione-a nas configurações do seu app Android no Console do Firebase ("Adicionar impressão digital").
    -   Após adicionar, baixe o arquivo `google-services.json` atualizado e substitua o que está em `android/app/`.

### 3. Configuração do Projeto Local

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