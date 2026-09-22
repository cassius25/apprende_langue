# 🏛️ Architecture — LangApp

> Vue d'ensemble de l'architecture logicielle, des choix techniques et des flux de données.

---

## 📑 Table des matières

- [Vue d'ensemble](#-vue-densemble)
- [Diagramme global](#-diagramme-global)
- [Architecture Flutter](#-architecture-flutter)
- [Architecture backend](#-architecture-backend)
- [Flux d'authentification](#-flux-dauthentification)
- [Flux offline-first](#-flux-offline-first)
- [Flux de synchronisation](#-flux-de-synchronisation)
- [Décisions techniques](#-décisions-techniques)
- [Contraintes & compromis](#-contraintes--compromis)

---

## 🎯 Vue d'ensemble

LangApp est composé de **trois couches** principales :

1. **Mobile (Flutter)** — Application cross-platform, offline-first, basée sur Clean Architecture + feature-first.
2. **Backend (Node.js + Express)** — API REST modulaire, authentifiée, scalable horizontalement.
3. **Base de données (PostgreSQL)** — 25 tables normalisées, UUID, soft delete, index ciblés.

Le tout est **conteneurisé** (Docker), **testé** (Jest + Flutter Test), et **déployé** via GitHub Actions + Caddy.

---

## 🌐 Diagramme global

```mermaid
flowchart TB
    subgraph Mobile["📱 Flutter Mobile"]
        UI["Presentation<br/>(Widgets + Riverpod)"]
        DOM["Domain<br/>(Usecases + Entities)"]
        DATA["Data<br/>(Repos + DataSources)"]
        DRIFT[("Drift<br/>SQLite")]
        SEC["SecureStorage<br/>(tokens)"]
        SYNC["Sync Engine"]

        UI --> DOM
        DOM --> DATA
        DATA --> DRIFT
        DATA --> SEC
        DATA --> SYNC
    end

    subgraph Backend["🖥️ Node.js API"]
        ROUTER["Express Router<br/>/api/v1"]
        MW["Middleware<br/>Auth · Zod · RateLimit"]
        SVC["Services"]
        REPO["Repositories<br/>(Prisma)"]
        PRISMA["Prisma ORM"]

        ROUTER --> MW
        MW --> SVC
        SVC --> REPO
        REPO --> PRISMA
    end

    DB[("🐘 PostgreSQL 16")]
    NET{{"HTTPS / REST"}}

    SYNC -.->|POST /sync| NET
    DATA -.->|Dio| NET
    NET --> ROUTER
    PRISMA --> DB
```

---

## 🧩 Architecture Flutter

### Clean Architecture + feature-first

Chaque **feature** est autonome et suit le triplet `data / domain / presentation` :

```mermaid
flowchart LR
    subgraph Feature["features/vocabulary/"]
        direction TB

        subgraph P["presentation/"]
            PAGES["pages/"]
            WIDGETS["widgets/"]
            PROV["providers/<br/>(Riverpod)"]
        end

        subgraph D["domain/"]
            ENT["entities/"]
            REPOIF["repositories/<br/>(interfaces)"]
            UC["usecases/"]
        end

        subgraph DA["data/"]
            DS["datasources/<br/>(Dio + Drift)"]
            MODELS["models/<br/>(DTOs)"]
            REPOIMPL["repositories/<br/>(impl)"]
        end

        P --> D
        D --> DA
    end
```

**Règles de dépendance** :
- ✅ `presentation` → `domain` → `data`
- ❌ Jamais l'inverse
- ❌ `domain` ne connaît ni Dio, ni Drift, ni Riverpod
- ✅ `data` implémente les interfaces `domain`

### Gestion d'état (Riverpod)

| Type de provider | Usage |
|---|---|
| `Provider` | DI (repos, datasources, services) |
| `FutureProvider` | Lecture async one-shot (catalogue, stats) |
| `StreamProvider` | Flux continus (connectivité, sync count) |
| `NotifierProvider` | État mutable complexe (auth, session, sync) |
| `FutureProvider.family` | Paramétrés (détail par id, query) |

### Arborescence type

```
lib/
├── core/                          # Infrastructure transversale
│   ├── config/app_env.dart        # dev/staging/prod
│   ├── constants/
│   ├── errors/app_failure.dart    # sealed class
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── auth_interceptor.dart  # JWT + refresh auto
│   │   ├── error_interceptor.dart
│   │   └── network_info.dart
│   ├── router/
│   ├── storage/
│   │   ├── secure_storage.dart
│   │   ├── preferences.dart
│   │   └── drift/                 # 20 tables
│   ├── sync/sync_scheduler.dart
│   ├── theme/                     # Material 3
│   └── utils/
│       ├── result.dart            # Either<Failure, T>
│       ├── sm2.dart               # Miroir SRS
│       └── validators.dart
│
├── features/
│   ├── auth/                      # Login, Register, ...
│   ├── onboarding/                # 7 étapes
│   ├── home/                      # Dashboard
│   ├── languages/
│   ├── courses/
│   ├── lessons/
│   ├── vocabulary/
│   ├── flashcards/
│   ├── exercises/                 # 7 types
│   ├── review/                    # SRS enrichi
│   ├── goals/
│   ├── streak/
│   ├── statistics/
│   ├── profile/
│   └── sync/
│
└── main.dart
```

---

## 🖥️ Architecture backend

### Modulaire + layered

```mermaid
flowchart TB
    REQ["HTTP Request"]
    ROUTER["routes/index.ts<br/>/api/v1/*"]
    VAL["Middleware chain<br/>requestId → rateLimit → validate → auth"]
    CTRL["Controller<br/>(HTTP mapping)"]
    SVC["Service<br/>(logique métier)"]
    REPO["Repository<br/>(Prisma)"]
    DB[("PostgreSQL")]

    REQ --> ROUTER
    ROUTER --> VAL
    VAL --> CTRL
    CTRL --> SVC
    SVC --> REPO
    REPO --> DB
```

**Règle d'or** :
- **Controller** : uniquement HTTP (req → params, res → json). Aucune logique.
- **Service** : toute la logique métier, aucune dépendance HTTP.
- **Repository** : accès Prisma, aucune logique métier.
- **Transaction** : orchestrée par le service.

### Modules

| Module | Responsabilité | Endpoints principaux |
|---|---|---|
| `auth` | Register, login, refresh, reset | `/auth/*` |
| `users` | Profil courant | `/users/me` |
| `languages` | Catalogue langues | `/languages` |
| `courses` | Cours + modules | `/courses` |
| `lessons` | Leçons + complétion | `/lessons` |
| `vocabulary` | Mots + traductions + user_vocabulary | `/vocabulary` |
| `exercises` | Correction + scoring | `/exercises` |
| `reviews` | SRS SM-2 + sessions | `/reviews` |
| `progress` | Progression leçons | `/progress` |
| `streaks` | Séries + calendrier | `/streak` |
| `goals` | Objectifs quotidiens | `/goals` |
| `statistics` | Agrégats | `/statistics` |
| `synchronization` | Push/pull offline | `/sync` |

### Middlewares transverses

```mermaid
flowchart LR
    IN["Request"] --> RID["requestId"]
    RID --> LOG["pinoHttp"]
    LOG --> SEC["helmet"]
    SEC --> CORS["cors"]
    CORS --> BODY["json body 1mb"]
    BODY --> LIM["rateLimit global"]
    LIM --> VAL["validate Zod"]
    VAL --> AUTH["authenticate JWT"]
    AUTH --> RBAC["authorize RBAC"]
    RBAC --> CTRL["Controller"]
    CTRL --> OUT["Response"]
    CTRL -.->|err| ERR["errorHandler"]
    ERR --> OUT
```

---

## 🔐 Flux d'authentification

```mermaid
sequenceDiagram
    participant M as Mobile (Flutter)
    participant D as Dio
    participant AI as AuthInterceptor
    participant API as API Node.js
    participant DB as PostgreSQL

    Note over M,DB: Inscription
    M->>D: POST /auth/register
    D->>API: { firstName, lastName, email, password }
    API->>API: hashPassword (Argon2id)
    API->>DB: INSERT user + refresh_token
    API-->>D: { user, tokens: { access, refresh } }
    D-->>M: AuthResult

    Note over M,DB: Requête authentifiée
    M->>D: GET /users/me
    D->>AI: Ajoute Authorization: Bearer <access>
    AI->>API: GET /users/me + Bearer
    API->>API: verifyAccessToken
    API->>DB: SELECT user
    API-->>M: { user }

    Note over M,DB: Expiration access token
    M->>D: POST /reviews
    D->>API: Bearer expiré
    API-->>D: 401 Unauthorized
    D->>AI: Intercepte 401
    AI->>API: POST /auth/refresh { refreshToken }
    API->>DB: Vérifie + révoque ancien + crée nouveau
    API-->>AI: { access, refresh } (rotation)
    AI->>AI: Save tokens
    AI->>API: Replay POST /reviews
    API-->>M: Success

    Note over M,DB: Détection de réutilisation
    M->>API: POST /auth/refresh avec ancien refresh
    API->>DB: Ancien déjà révoqué → détection
    API->>DB: UPDATE refresh_token SET revokedAt = now() (TOUS)
    API-->>M: 401 reuse detected
```

**Sécurité** :
- **Access token** : JWT HS256, 15 min, contient `sub`, `email`, `role`, `emailVerified`.
- **Refresh token** : opaque (32 octets base64url), hashé SHA-256 en DB, rotation à chaque usage.
- **Détection de réutilisation** : si un refresh révoqué est présenté → toutes les sessions de l'utilisateur sont révoquées.

---

## 📴 Flux offline-first

```mermaid
flowchart TB
    USER["Action utilisateur<br/>(learn a word, complete lesson)"]
    USER --> LOCAL["Écriture locale Drift"]
    LOCAL --> ENQUEUE["SyncQueueDao.enqueue<br/>status = pending"]
    ENQUEUE --> UI["UI mise à jour<br/>immédiatement"]

    ENQUEUE -.->|déclencheur| SCHED["SyncScheduler"]
    SCHED --> CHECK{"Connecté ?"}
    CHECK -->|Non| OFFLINE["Reste pending"]
    CHECK -->|Oui| CYCLE["SyncCycle.run()"]

    CYCLE --> PUSH["POST /sync<br/>push operations"]
    PUSH --> SERVER["Serveur applique<br/>(ou rejette)"]
    SERVER --> RESP["Response<br/>applied / failed / changes"]
    RESP --> APPLY["SyncPullApplier<br/>met à jour Drift"]
    RESP --> MARK["markSynced / markFailed"]

    MARK -.->|si failed| RETRY["Retry exponentiel<br/>1s → 2s → 4s → 8s → 16s"]
    RETRY --> PUSH
```

**Déclencheurs** :
1. Démarrage de l'app (après auth)
2. Retour de connectivité
3. Timer périodique (5 min)
4. Retour foreground (`WidgetsBindingObserver`)
5. Action utilisateur (bouton manuel)

---

## 🔄 Flux de synchronisation

```mermaid
sequenceDiagram
    participant M as Mobile
    participant SQ as SyncQueueDao
    participant SR as SyncRepository
    participant API as API
    participant PA as SyncPullApplier
    participant DB as Drift

    M->>SQ: enqueue(op1, op2, op3)
    Note over SQ: status = pending

    M->>SR: runCycle()
    SR->>SQ: getPendingBatch(100)
    SQ-->>SR: [op1, op2, op3]

    SR->>SQ: markInFlight([op1, op2, op3])
    SR->>API: POST /sync { since, operations }

    Note over API: Déduplique par opId<br/>Vérifie LWW<br/>Applique les valides
    API-->>SR: { applied, failed, changes, serverTime }

    SR->>SQ: markSynced(applied)
    SR->>SQ: markFailed(failed, reason)
    SR->>PA: apply(changes)
    PA->>DB: Upsert user_vocabulary,<br/>user_progress, ...
    SR->>SR: setLastSyncAt(serverTime)
    SR->>SQ: purgeSynced(older than 7d)
    SR-->>M: SyncCycleResult
```

**Idempotence** : chaque opération a un UUID client. Si déjà traité, le serveur retourne sans erreur (ni `applied` ni `failed`).

**Résolution de conflits** : last-write-wins basé sur `updatedAt` (comparé au `clientTimestamp`). Exception : `user_progress.COMPLETED` côté client gagne toujours.

**Soft delete** : propagé via `deletedAt`. Résurrection possible par UPSERT si `clientTimestamp > updatedAt`.

---

## 🎯 Décisions techniques

### Pourquoi Riverpod (vs Bloc, Provider, GetX) ?

| Critère | Riverpod | Bloc | Provider |
|---|---|---|---|
| Compile-safe | ✅ | ✅ | ❌ |
| Testable sans BuildContext | ✅ | ✅ | ❌ |
| Pas de `ProviderNotFoundException` | ✅ | ✅ | ❌ |
| Boilerplate | Moyen | Élevé | Faible |
| Offline-friendly (family, autoDispose) | ✅ | ⚠️ | ❌ |

### Pourquoi Drift (vs Hive, sqflite, Isar) ?

| Critère | Drift | Hive | sqflite | Isar |
|---|---|---|---|---|
| Typé | ✅ | ⚠️ | ❌ | ✅ |
| SQL relationnel | ✅ | ❌ | ✅ | ❌ |
| Migrations | ✅ | ❌ | Manuel | ⚠️ |
| Codegen | ✅ | ❌ | ❌ | ✅ |
| Miroir backend | ✅ | ❌ | ✅ | ❌ |

Drift permet de **refléter exactement** le schéma PostgreSQL, ce qui simplifie la sync (mêmes colonnes, mêmes types).

### Pourquoi Prisma (vs TypeORM, Sequelize, Knex) ?

- Migrations versionnées et rejouables
- Client TypeScript **fully typed** généré
- Requêtes paramétrées (protection SQL injection native)
- Studio pour l'inspection visuelle
- Seed natif

### Pourquoi SM-2 (vs FSRS, Leitner) ?

- Standard éprouvé (SuperMemo, Anki)
- Simple à implémenter et à tester
- Extensible vers FSRS sans migration de schéma
- Miroir client/serveur trivial

### Pourquoi Caddy (vs Nginx, Traefik) ?

- HTTPS **automatique** (Let's Encrypt)
- Config Caddyfile **5x plus courte** que Nginx
- Health check upstream natif
- Logs JSON rotatifs natifs

---

## ⚖️ Contraintes & compromis

| Contrainte | Compromis retenu |
|---|---|
| Offline complet impossible | Soft deletes propagés, résurrection par UPSERT |
| Conflits multi-device | LWW sur `updatedAt` (99 % des cas OK) |
| Taille de l'APK | Split ABI + R8 (proguard) |
| Cold start | Splash + init DB en parallèle, `< 2s` |
| Coût serveur | 1 VPS 2 vCPU/2GB suffit pour 10k users |
| Sécurité | Rate limit global, JWT courts, rotation, Helmet |
| Contenu | Seed minimal + admin via API (P22+) |

---

## 📚 Voir aussi

- [API Reference](./api.md)
- [Database Schema](./database.md)
- [Offline Sync](./offline-sync.md)
- [Deployment Guide](../deploy/README.md)
