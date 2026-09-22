# 🔌 API Reference — LangApp

> Référence complète des endpoints REST. Base URL : `/api/v1`.

---

## 📑 Table des matières

- [Conventions](#-conventions)
- [Authentification](#-authentification)
- [Utilisateurs](#-utilisateurs)
- [Langues](#-langues)
- [Cours & Modules](#-cours--modules)
- [Leçons](#-leçons)
- [Vocabulaire](#-vocabulaire)
- [Exercices](#-exercices)
- [Révisions (SRS)](#-révisions-srs)
- [Progression](#-progression)
- [Streaks](#-streaks)
- [Objectifs](#-objectifs)
- [Statistiques](#-statistiques)
- [Synchronisation](#-synchronisation)
- [Erreurs](#-erreurs)

---

## 📐 Conventions

### Base URL

```
https://api.example.com/api/v1
```

### Headers

| Header | Valeur | Obligatoire |
|---|---|---|
| `Content-Type` | `application/json` | Pour POST/PATCH |
| `Authorization` | `Bearer <accessToken>` | Endpoints authentifiés |
| `X-Request-Id` | UUID | Optionnel (traçabilité) |

### Format de réponse

**Succès** :
```json
{
  "success": true,
  "data": { /* ... */ },
  "meta": { /* pagination, optionnel */ }
}
```

**Erreur** :
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": { /* optionnel */ }
  }
}
```

### Codes d'erreur

| Code | HTTP | Description |
|---|---|---|
| `BAD_REQUEST` | 400 | Requête invalide |
| `UNAUTHORIZED` | 401 | Token manquant/invalide/expiré |
| `FORBIDDEN` | 403 | Rôle insuffisant |
| `NOT_FOUND` | 404 | Ressource introuvable |
| `CONFLICT` | 409 | Violation d'unicité |
| `VALIDATION_ERROR` | 422 | Payload invalide (Zod) |
| `RATE_LIMITED` | 429 | Trop de requêtes |
| `INTERNAL_ERROR` | 500 | Erreur serveur |

### Pagination

Query params : `?page=1&limit=20`

Réponse :
```json
{
  "success": true,
  "data": [ /* ... */ ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8,
    "hasNext": true,
    "hasPrev": false
  }
}
```

### Authentification

Toutes les routes marquées 🔒 requièrent `Authorization: Bearer <accessToken>`.

---

## 🔐 Authentification

### POST `/auth/register`

Créer un compte utilisateur.

**Body** :
```json
{
  "firstName": "Alice",
  "lastName": "Martin",
  "email": "alice@example.com",
  "password": "Password123",
  "nativeLanguageId": "uuid-fr",
  "learningLanguageId": "uuid-en"
}
```

**Réponse 201** :
```json
{
  "success": true,
  "data": {
    "user": { "id": "...", "email": "...", "firstName": "Alice", ... },
    "tokens": {
      "accessToken": "eyJhbGci...",
      "refreshToken": "dGhpc19pc19h...",
      "accessTokenExpiresIn": 900,
      "refreshTokenExpiresAt": "2025-02-15T10:00:00.000Z"
    }
  }
}
```

**Erreurs** : `409` (email déjà pris), `422` (payload invalide).

---

### POST `/auth/login`

Connexion.

**Body** :
```json
{ "email": "alice@example.com", "password": "Password123" }
```

**Réponse 200** : identique à `/register`.

**Erreurs** : `401` (identifiants invalides, anti-énumération).

---

### POST `/auth/refresh`

Rotation des tokens.

**Body** : `{ "refreshToken": "..." }`

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "tokens": {
      "accessToken": "...",
      "refreshToken": "...",  // nouveau
      "accessTokenExpiresIn": 900,
      "refreshTokenExpiresAt": "..."
    }
  }
}
```

**Erreurs** : `401` (invalide, expiré, ou **réutilisation détectée** → toutes les sessions révoquées).

---

### POST `/auth/logout`

Révoque le refresh token courant. **Idempotent**.

**Body** : `{ "refreshToken": "..." }`
**Réponse** : `204 No Content`.

---

### POST `/auth/logout-all` 🔒

Révoque **toutes** les sessions de l'utilisateur.
**Réponse** : `204`.

---

### POST `/auth/forgot-password`

Envoie un email de réinitialisation.

**Body** : `{ "email": "..." }`
**Réponse** : `202 Accepted` (toujours, anti-énumération).

---

### POST `/auth/reset-password`

Réinitialise le mot de passe avec un token.

**Body** :
```json
{ "token": "abc...", "newPassword": "NewPassword123" }
```

**Réponse** : `204`. Toutes les sessions sont révoquées.

**Erreurs** : `400` (token invalide/expiré).

---

### POST `/auth/verify-email`

Vérifie l'email.

**Body** : `{ "token": "..." }`
**Réponse** : `200`.

---

### POST `/auth/resend-verification` 🔒

Renvoie l'email de vérification.
**Réponse** : `202`.

---

## 👤 Utilisateurs

### GET `/users/me` 🔒

Profil de l'utilisateur courant.

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "id": "...",
    "email": "alice@example.com",
    "firstName": "Alice",
    "lastName": "Martin",
    "role": "USER",
    "emailVerified": true,
    "nativeLanguageId": "uuid-fr",
    "xp": 1250,
    "userLevel": 7,
    "lastLoginAt": "2025-01-15T10:00:00.000Z",
    "createdAt": "2025-01-01T00:00:00.000Z",
    "updatedAt": "2025-01-15T10:00:00.000Z"
  }
}
```

---

### PATCH `/users/me` 🔒

Modifie le profil.

**Body** (tous optionnels) :
```json
{
  "firstName": "Alicia",
  "lastName": "Martin",
  "nativeLanguageId": "uuid-fr"
}
```

**Réponse 200** : profil mis à jour.

---

### POST `/users/me/change-password` 🔒

**Body** :
```json
{ "currentPassword": "OldPassword123", "newPassword": "NewPassword456" }
```

**Réponse** : `204`. Sessions révoquées.

**Erreurs** : `401` (mot de passe courant incorrect).

---

### DELETE `/users/me` 🔒

Suppression du compte (soft delete + anonymisation).

**Body** : `{ "password": "Password123" }`
**Réponse** : `204`.

---

## 🌍 Langues

### GET `/languages` *(public)*

Liste des langues actives.

**Query** : `?activeOnly=true` (défaut `true`)

**Réponse 200** :
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "code": "fr",
      "name": "Français",
      "nativeName": "Français",
      "flagEmoji": "🇫🇷",
      "isActive": true
    }
  ]
}
```

---

### GET `/languages/:id` *(public)*

**Réponse 200** : même format que ci-dessus.

---

### GET `/languages/:id/levels` *(public)*

Niveaux CECRL disponibles pour une langue.

**Réponse 200** :
```json
{
  "success": true,
  "data": [
    { "id": "uuid", "code": "A1", "name": "Débutant", "order": 1 }
  ]
}
```

---

### POST `/languages` 🔒 *(ADMIN, CONTENT_MANAGER)*

**Body** :
```json
{ "code": "it", "name": "Italien", "nativeName": "Italiano", "flagEmoji": "🇮🇹" }
```

**Réponse 201**. Erreurs : `409` (code déjà pris).

---

### PATCH `/languages/:id` 🔒 *(ADMIN, CONTENT_MANAGER)*
### DELETE `/languages/:id` 🔒 *(ADMIN, CONTENT_MANAGER)*

---

## 📚 Cours & Modules

### GET `/courses` 🔒

**Query** : `?languageId=uuid&languageCode=en&levelCode=A1&includeDrafts=false&page=1&limit=20`

**Réponse 200** :
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "title": "Anglais A1 — Débutant",
      "description": "...",
      "order": 1,
      "isPublished": true,
      "language": { "id": "...", "code": "en", "name": "Anglais", "flagEmoji": "🇬🇧" },
      "level": { "id": "...", "code": "A1", "name": "Débutant" },
      "moduleCount": 5,
      "lessonCount": 20
    }
  ],
  "meta": { /* pagination */ }
}
```

---

### GET `/courses/:id` 🔒

Renvoie la hiérarchie complète (modules + leçons).

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "title": "...",
    "modules": [
      {
        "id": "uuid",
        "title": "Se présenter",
        "order": 1,
        "lessons": [
          { "id": "uuid", "title": "Hello", "order": 1, "estimatedDuration": 8, "isPublished": true }
        ]
      }
    ]
  }
}
```

---

### POST `/courses` 🔒 *(ADMIN, CONTENT_MANAGER)*
### PATCH `/courses/:id` 🔒 *(ADMIN, CONTENT_MANAGER)*
### DELETE `/courses/:id` 🔒 *(ADMIN, CONTENT_MANAGER)*
### POST `/courses/:id/modules` 🔒 *(ADMIN, CONTENT_MANAGER)*

---

## 📖 Leçons

### GET `/lessons/:id` 🔒

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "title": "Hello, my name is...",
    "description": "...",
    "order": 1,
    "estimatedDuration": 8,
    "module": { "id": "...", "title": "..." },
    "course": { "id": "...", "title": "..." },
    "language": { "id": "...", "code": "en", "name": "Anglais" },
    "level": { "id": "...", "code": "A1", "name": "Débutant" },
    "contents": [
      { "id": "uuid", "type": "MARKDOWN", "content": "# Hello!", "order": 1 }
    ],
    "exercises": [
      {
        "id": "uuid",
        "type": "MULTIPLE_CHOICE",
        "question": "What does \"apple\" mean?",
        "order": 1,
        "options": [
          { "id": "uuid", "label": "Pomme", "order": 1 }
        ]
      }
    ],
    "progress": {
      "status": "IN_PROGRESS",
      "score": 0,
      "timeSpentSec": 240,
      "completedAt": null
    }
  }
}
```

> ⚠️ **`correctAnswer` et `isCorrect` ne sont jamais exposés** avant soumission d'un exercice.

---

### POST `/lessons/:id/complete` 🔒

Marque la leçon comme terminée.

**Body** :
```json
{ "score": 90, "timeSpentSec": 420 }
```

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "progress": { "status": "COMPLETED", "score": 90, "timeSpentSec": 420, "completedAt": "..." },
    "xpEarned": 18,
    "totalXp": 1268,
    "userLevel": 7,
    "streak": {
      "currentStreak": 3,
      "longestStreak": 12,
      "totalActiveDays": 45,
      "lastActiveDate": "2025-01-15"
    },
    "newBadges": [
      { "code": "FIRST_LESSON", "name": "Première leçon", "icon": "🏆" }
    ]
  }
}
```

---

## 🗂️ Vocabulaire

### GET `/vocabulary` 🔒

**Query** : `?languageCode=en&levelCode=A1&category=food&search=apple&page=1&limit=20`

**Réponse 200** :
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "word": "apple",
      "phonetic": "/ˈæpəl/",
      "audioUrl": "https://...",
      "imageUrl": "https://...",
      "category": "food",
      "partOfSpeech": "noun",
      "language": { "id": "...", "code": "en", "name": "Anglais", "flagEmoji": "🇬🇧" },
      "level": { "id": "...", "code": "A1", "name": "Débutant" },
      "translations": [
        { "id": "...", "languageId": "...", "languageCode": "fr", "languageName": "Français", "translation": "pomme" }
      ],
      "examples": [
        { "id": "...", "sentence": "I eat an apple.", "translation": "Je mange une pomme.", "audioUrl": null, "order": 1 }
      ]
    }
  ],
  "meta": { /* pagination */ }
}
```

---

### GET `/vocabulary/:id` 🔒

Détail d'un mot.

---

### GET `/vocabulary/me` 🔒

Mots suivis par l'utilisateur.

**Query** : `?state=LEARNING&isFavorite=true&languageId=uuid&search=...&page=1&limit=200`

**Réponse 200** : liste d'`UserVocabularyDto` (word + state + SRS + translations + examples).

---

### GET `/vocabulary/me/favorites` 🔒

Mots favoris.

---

### GET `/vocabulary/me/due` 🔒

Mots à réviser **maintenant** (state `LEARNING|REVIEW` et `nextReviewAt ≤ now`).

**Query** : `?limit=50&languageId=uuid`

---

### POST `/vocabulary/me/learn` 🔒

Démarre l'apprentissage d'un mot. **Idempotent**.

**Body** : `{ "vocabularyId": "uuid" }`
**Réponse 201**.

---

### PATCH `/vocabulary/me/:vocabularyId/favorite` 🔒

**Body** : `{ "isFavorite": true }`
**Réponse 200**.

---

### PATCH `/vocabulary/me/:vocabularyId/state` 🔒

**Body** : `{ "state": "MASTERED" }` (`NEW` | `LEARNING` | `REVIEW` | `MASTERED`)
**Réponse 200**.

---

### POST `/vocabulary` 🔒 *(ADMIN, CONTENT_MANAGER)*
### PATCH `/vocabulary/:id` 🔒 *(ADMIN, CONTENT_MANAGER)*
### DELETE `/vocabulary/:id` 🔒 *(ADMIN, CONTENT_MANAGER)*
### POST `/vocabulary/:id/translations` 🔒 *(ADMIN, CONTENT_MANAGER)*
### POST `/vocabulary/:id/examples` 🔒 *(ADMIN, CONTENT_MANAGER)*

---

## 🎯 Exercices

### POST `/exercises/:id/submit` 🔒

Soumet une réponse à un exercice. **Correction server-side**.

**Body** (dépend du type) :
```jsonc
// MULTIPLE_CHOICE / LISTENING
{ "answer": { "optionId": "uuid" }, "responseTimeMs": 3200 }

// TRANSLATION
{ "answer": { "text": "Je suis étudiant." } }

// FILL_IN_THE_BLANK (texte OU option)
{ "answer": { "text": "am" } }
{ "answer": { "optionId": "uuid" } }

// MATCHING
{ "answer": { "pairs": [
  { "left": "Apple", "right": "Pomme" },
  { "left": "House", "right": "Maison" }
]}}

// WORD_ORDER
{ "answer": { "words": ["I", "am", "a", "student"] } }

// PRONUNCIATION
{ "answer": {} }
```

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "exerciseId": "uuid",
    "isCorrect": true,
    "score": 100,
    "correctAnswer": "Pomme",
    "explanation": "Apple = pomme (fruit).",
    "details": { "similarity": 1.0 },
    "xpEarned": 10,
    "totalXp": 1278,
    "userLevel": 7,
    "streak": { "currentStreak": 3, "longestStreak": 12, "totalActiveDays": 45, "lastActiveDate": "2025-01-15" },
    "newBadges": []
  }
}
```

**Barème** :

| Type | Cas | Score |
|---|---|---|
| `MULTIPLE_CHOICE` | Bonne option | 100 |
| `TRANSLATION` | Fuzzy ≥ 0.90 | 100 |
| `FILL_IN_THE_BLANK` | Fuzzy ≥ 0.92 | 100 |
| `MATCHING` | Toutes paires correctes | 100 |
| `MATCHING` | Partiel | `correct/total × 100` |
| `WORD_ORDER` | Ordre exact | 100 |
| `WORD_ORDER` | Mêmes mots, mauvais ordre | 60 |
| `PRONUNCIATION` | Défaut (stub STT) | 100 |

**XP** : `5 + round(score / 100 × 5)` — entre 5 et 10 XP.

---

### POST `/exercises/lessons/:lessonId/submit` 🔒

Soumission **batch** pour toute une leçon.

**Body** :
```json
{
  "answers": [
    { "exerciseId": "uuid", "answer": { "optionId": "uuid" }, "responseTimeMs": 3200 },
    { "exerciseId": "uuid", "answer": { "text": "Je suis étudiant." } }
  ]
}
```

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "results": [ /* CorrectionResult[] */ ],
    "correctCount": 3,
    "totalCount": 5,
    "overallScore": 80,
    "xpEarned": 42,
    "totalXp": 1320,
    "userLevel": 7,
    "streak": { ... },
    "newBadges": [ ... ]
  }
}
```

---

## 🔁 Révisions (SRS)

### GET `/reviews/today` 🔒

File de révision du jour.

**Query** : `?limit=50&languageId=uuid&includeNew=false`

**Réponse 200** :
```json
{
  "success": true,
  "data": [
    {
      "userVocabularyId": "uuid",
      "vocabularyId": "uuid",
      "word": "apple",
      "phonetic": "/ˈæpəl/",
      "audioUrl": "https://...",
      "imageUrl": null,
      "translations": [{ "languageCode": "fr", "translation": "pomme" }],
      "examples": [{ "sentence": "I eat an apple.", "translation": "Je mange une pomme." }],
      "state": "LEARNING",
      "repetitions": 1,
      "intervalDays": 1,
      "easeFactor": 2.5,
      "nextReviewAt": "2025-01-15T10:00:00.000Z"
    }
  ]
}
```

---

### GET `/reviews/due-count` 🔒

Compteur de cartes à réviser.

**Réponse 200** : `{ "success": true, "data": { "dueCount": 15 } }`

---

### POST `/reviews` 🔒

Soumet une révision (SM-2).

**Body** :
```json
{ "userVocabularyId": "uuid", "quality": 4, "responseTimeMs": 3400 }
```

**Qualité SM-2** : `0` (blackout) à `5` (parfait). `q ≥ 3` = succès.

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "userVocabularyId": "uuid",
    "quality": 4,
    "isCorrect": true,
    "previous": { "state": "LEARNING", "repetitions": 1, "intervalDays": 1, "easeFactor": 2.5 },
    "current": {
      "state": "REVIEW",
      "repetitions": 2,
      "intervalDays": 6,
      "easeFactor": 2.5,
      "successRate": 1,
      "difficulty": 0,
      "nextReviewAt": "2025-01-21T10:00:00.000Z"
    },
    "nextReviewInDays": 6,
    "xpEarned": 6,
    "totalXp": 1326,
    "userLevel": 7,
    "streak": { ... },
    "newBadges": []
  }
}
```

**XP** : échec = 2 XP ; succès = `5 + (q - 3)` (donc 5, 6 ou 7 XP).

---

### POST `/reviews/batch` 🔒

Soumet une session complète.

**Body** :
```json
{
  "reviews": [
    { "userVocabularyId": "uuid-1", "quality": 5 },
    { "userVocabularyId": "uuid-2", "quality": 3 }
  ]
}
```

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "results": [ /* ReviewResult[] */ ],
    "totalXpEarned": 11,
    "totalXp": 1337,
    "userLevel": 7,
    "streak": { ... },
    "newBadges": []
  }
}
```

---

## 📈 Progression

### GET `/progress` 🔒

Vue globale.

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "totalXp": 1337,
    "userLevel": 7,
    "xpInCurrentLevel": 137,
    "xpToNextLevel": 63,
    "lessonsCompleted": 12,
    "lessonsTotal": 200,
    "vocabularyTotal": 45,
    "vocabularyMastered": 8,
    "languages": [
      {
        "language": { "id": "...", "code": "en", "name": "Anglais", "flagEmoji": "🇬🇧" },
        "currentLevel": { "id": "...", "code": "A1", "name": "Débutant" },
        "progressPercent": 35.5,
        "isActive": true,
        "startedAt": "2025-01-01T00:00:00.000Z",
        "levels": [
          { "id": "uuid", "code": "A1", "name": "Débutant", "order": 1, "progressPercent": 80, "lessonsCompleted": 8, "lessonsTotal": 10 }
        ],
        "lessonsCompleted": 12,
        "lessonsTotal": 40,
        "vocabularyLearned": 45,
        "vocabularyMastered": 8
      }
    ],
    "currentStreak": 3,
    "longestStreak": 12,
    "dueToday": 15
  }
}
```

---

### GET `/progress/languages/:languageId` 🔒

Progression détaillée pour une langue.

---

### GET `/progress/lessons` 🔒

Liste paginée des leçons avec progression.

**Query** : `?languageId=uuid&status=COMPLETED&page=1&limit=20`

---

## 🔥 Streaks

### GET `/streak` 🔒

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "currentStreak": 3,
    "longestStreak": 12,
    "totalActiveDays": 45,
    "lastActiveDate": "2025-01-15",
    "activeToday": true,
    "daysUntilStreakLoss": 0
  }
}
```

---

### GET `/streak/calendar` 🔒

**Query** : `?days=30&offset=0`

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "from": "2024-12-17",
    "to": "2025-01-15",
    "days": [
      {
        "date": "2024-12-17",
        "active": true,
        "minutesLearned": 15,
        "xpEarned": 45,
        "wordsLearned": 3,
        "wordsReviewed": 8,
        "exercisesDone": 12
      }
    ]
  }
}
```

---

## 🎯 Objectifs

### GET `/goals` 🔒
Liste des objectifs actifs.

### GET `/goals/today` 🔒
Progression sur l'objectif du jour.

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "goal": { "id": "uuid", "type": "MINUTES", "target": 15, "isActive": true },
    "current": 12,
    "target": 15,
    "progressPercent": 80,
    "achieved": false,
    "minutesLearned": 12,
    "wordsLearned": 4
  }
}
```

---

### POST `/goals` 🔒
Upsert d'un objectif (idempotent par `type`).

**Body** : `{ "type": "MINUTES", "target": 15 }`

### PATCH `/goals/:id` 🔒
### DELETE `/goals/:id` 🔒

---

## 📊 Statistiques

### GET `/statistics` 🔒

Vue d'ensemble complète.

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "timeLearnedMinutes": { "total": 480, "last7Days": 90, "last30Days": 320 },
    "words": { "learned": 45, "mastered": 8, "reviewedTotal": 320, "dueToday": 15 },
    "exercises": { "done": 120, "correct": 96, "successRate": 80 },
    "lessons": { "completed": 12, "total": 200, "completionPercent": 6 },
    "xp": { "total": 1337, "level": 7, "xpInLevel": 137, "xpToNextLevel": 63 },
    "streak": { "current": 3, "longest": 12, "totalActiveDays": 45 }
  }
}
```

---

### GET `/statistics/activity` 🔒

**Query** : `?days=30&offset=0`

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "from": "2024-12-17",
    "to": "2025-01-15",
    "days": [
      { "date": "2024-12-17", "minutesLearned": 15, "xpEarned": 45, "wordsLearned": 3, "wordsReviewed": 8, "exercisesDone": 12, "exercisesCorrect": 10 }
    ],
    "totals": { "minutesLearned": 480, "xpEarned": 1337, "wordsLearned": 45, "wordsReviewed": 320, "exercisesDone": 120, "exercisesCorrect": 96 }
  }
}
```

---

### GET `/statistics/skills` 🔒

**Query** : `?languageId=uuid`

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "languageId": null,
    "skills": [
      { "skill": "VOCABULARY", "progressPercent": 17.8, "metrics": { "learned": 45, "mastered": 8 } },
      { "skill": "GRAMMAR", "progressPercent": 45, "metrics": { "exercisesInGrammar": 40, "completed": 18 } },
      { "skill": "LISTENING", "progressPercent": 20, "metrics": { ... } },
      { "skill": "READING", "progressPercent": 6, "metrics": { ... } },
      { "skill": "SPEAKING", "progressPercent": 12, "metrics": { ... } },
      { "skill": "WRITING", "progressPercent": 30, "metrics": { ... } }
    ]
  }
}
```

---

## 🔄 Synchronisation

### POST `/sync` 🔒

Endpoint unique push + pull.

**Body** :
```json
{
  "since": "2025-01-15T09:00:00.000Z",
  "operations": [
    {
      "id": "client-uuid-1",
      "entity": "user_vocabulary",
      "entityId": "vocabulary-uuid",
      "op": "UPSERT",
      "clientTimestamp": "2025-01-15T10:00:00.000Z",
      "payload": {
        "state": "LEARNING",
        "isFavorite": false,
        "repetitions": 0,
        "intervalDays": 0,
        "easeFactor": 2.5,
        "successRate": 0,
        "difficulty": 0,
        "nextReviewAt": "2025-01-15T10:00:00.000Z",
        "lastReviewedAt": null
      }
    }
  ]
}
```

**Entities syncables** : `user_vocabulary`, `user_progress`, `daily_goals`, `user_languages`.

**Réponse 200** :
```json
{
  "success": true,
  "data": {
    "serverTime": "2025-01-15T10:01:00.000Z",
    "applied": ["client-uuid-1"],
    "failed": [
      { "id": "client-uuid-2", "reason": "CONFLICT", "message": "Server version is newer" }
    ],
    "changes": {
      "user_vocabulary": [ /* rows modifiées */ ],
      "user_progress": [],
      "daily_goals": [],
      "user_languages": [],
      "streaks": [ /* server-authoritative */ ],
      "user_badges": [],
      "daily_activity": []
    },
    "changesCount": 12
  }
}
```

**Idempotence** : `id` UUID client. Si déjà traité → ignoré silencieusement (ni `applied` ni `failed`).

**Conflits** : last-write-wins sur `updatedAt`. Exception : `user_progress.COMPLETED` gagne toujours.

---

## ❗ Erreurs

### Format standard

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": {
      "fieldErrors": {
        "email": ["Invalid email"],
        "password": ["Password must be at least 8 characters"]
      }
    }
  }
}
```

### Validation Zod

Le champ `details` contient le résultat de `error.flatten()` de Zod :
```json
{
  "fieldErrors": { "email": ["..."] },
  "formErrors": []
}
```

### Rate limiting

**Headers** :
- `RateLimit-Limit: 200`
- `RateLimit-Remaining: 195`
- `RateLimit-Reset: 1705316400`

**Réponse 429** :
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMITED",
    "message": "Too many requests, please try again later."
  }
}
```

---

## 🧪 Exemples complets

### Cycle d'apprentissage complet

```bash
BASE=https://api.example.com/api/v1

# 1. S'inscrire
curl -X POST $BASE/auth/register \
  -H 'Content-Type: application/json' \
  -d '{
    "firstName":"Alice","lastName":"Martin",
    "email":"alice@example.com","password":"Password123"
  }'
# → access + refresh tokens

# 2. Lister les langues
curl $BASE/languages | jq

# 3. Lister les cours d'anglais A1
ACCESS="<access_token>"
curl "$BASE/courses?languageCode=en&levelCode=A1" -H "Authorization: Bearer $ACCESS" | jq

# 4. Détail du cours (modules + leçons)
curl $BASE/courses/<courseId> -H "Authorization: Bearer $ACCESS" | jq

# 5. Lire une leçon
curl $BASE/lessons/<lessonId> -H "Authorization: Bearer $ACCESS" | jq

# 6. Compléter la leçon
curl -X POST $BASE/lessons/<lessonId>/complete \
  -H "Authorization: Bearer $ACCESS" -H 'Content-Type: application/json' \
  -d '{"score":90,"timeSpentSec":420}' | jq
# → +18 XP, streak=1

# 7. Soumettre un exercice
curl -X POST $BASE/exercises/<exId>/submit \
  -H "Authorization: Bearer $ACCESS" -H 'Content-Type: application/json' \
  -d '{"answer":{"optionId":"<correctOptionId>"}}' | jq
# → isCorrect:true, score:100, correctAnswer:"Pomme"

# 8. Démarrer l'apprentissage d'un mot
curl -X POST $BASE/vocabulary/me/learn \
  -H "Authorization: Bearer $ACCESS" -H 'Content-Type: application/json' \
  -d '{"vocabularyId":"<vocabId>"}' | jq

# 9. Réviser une carte (SM-2)
curl -X POST $BASE/reviews \
  -H "Authorization: Bearer $ACCESS" -H 'Content-Type: application/json' \
  -d '{"userVocabularyId":"<uvId>","quality":5}' | jq
# → repetitions:1, intervalDays:1, nextReviewAt:+1 jour

# 10. Consulter statistiques
curl $BASE/statistics -H "Authorization: Bearer $ACCESS" | jq
curl $BASE/statistics/skills -H "Authorization: Bearer $ACCESS" | jq

# 11. Vérifier le streak
curl $BASE/streak -H "Authorization: Bearer $ACCESS" | jq
```

---

## 🔗 Voir aussi

- [Architecture](./architecture.md)
- [Database Schema](./database.md)
- [Offline Sync](./offline-sync.md)
- [Swagger UI](https://api.example.com/docs) — documentation interactive
