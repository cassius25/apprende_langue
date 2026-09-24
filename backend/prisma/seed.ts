// ============================================================
// Seed — langues, niveaux CECRL, badges, contenu de démo
// ============================================================
import { PrismaClient, CefrLevel, ExerciseType } from '../../generated/prisma/client';

const prisma = new PrismaClient();

async function main() {
    console.log('🌱 Seeding database...');

    // ── Languages ────────────────────────────────────────────
    const languagesData = [
        { code: 'fr', name: 'Français', nativeName: 'Français', flagEmoji: '🇫🇷' },
        { code: 'en', name: 'Anglais', nativeName: 'English', flagEmoji: '🇬🇧' },
        { code: 'es', name: 'Espagnol', nativeName: 'Español', flagEmoji: '🇪🇸' },
        { code: 'de', name: 'Allemand', nativeName: 'Deutsch', flagEmoji: '🇩🇪' },
        { code: 'it', name: 'Italien', nativeName: 'Italiano', flagEmoji: '🇮🇹' },
        { code: 'pt', name: 'Portugais', nativeName: 'Português', flagEmoji: '🇵🇹' },
        { code: 'ar', name: 'Arabe', nativeName: 'العربية', flagEmoji: '🇸🇦' },
        { code: 'zh', name: 'Chinois', nativeName: '中文', flagEmoji: '🇨🇳' },
    ];

    for (const lang of languagesData) {
        await prisma.language.upsert({
            where: { code: lang.code },
            update: lang,
            create: lang,
        });
    }

    // ── CEFR Levels ──────────────────────────────────────────
    const levelsData: { code: CefrLevel; name: string; order: number; description: string }[] = [
        { code: 'A1', name: 'Débutant', order: 1, description: 'Niveau introductif ou découverte' },
        { code: 'A2', name: 'Élémentaire', order: 2, description: 'Niveau intermédiaire ou de survie' },
        { code: 'B1', name: 'Intermédiaire', order: 3, description: 'Niveau seuil' },
        { code: 'B2', name: 'Intermédiaire avancé', order: 4, description: 'Niveau avancé ou indépendant' },
        { code: 'C1', name: 'Avancé', order: 5, description: 'Niveau autonome' },
        { code: 'C2', name: 'Maîtrise', order: 6, description: 'Niveau de maîtrise' },
    ];

    for (const level of levelsData) {
        await prisma.level.upsert({
            where: { code: level.code },
            update: level,
            create: level,
        });
    }

    // ── Badges ───────────────────────────────────────────────
    const badgesData = [
        { code: 'STREAK_7', name: '7 jours consécutifs', description: 'Apprendre 7 jours de suite', icon: '🔥', condition: { type: 'STREAK', value: 7 } },
        { code: 'STREAK_30', name: '30 jours consécutifs', description: 'Apprendre 30 jours de suite', icon: '🔥', condition: { type: 'STREAK', value: 30 } },
        { code: 'WORDS_100', name: '100 mots appris', description: 'Apprendre 100 mots', icon: '📚', condition: { type: 'WORDS', value: 100 } },
        { code: 'EXERCISES_100', name: '100 exercices réussis', description: 'Réussir 100 exercices', icon: '🎯', condition: { type: 'EXERCISES', value: 100 } },
        { code: 'FIRST_LESSON', name: 'Première leçon', description: 'Terminer sa première leçon', icon: '🏆', condition: { type: 'LESSON', value: 1 } },
        { code: 'FIRST_LANGUAGE', name: 'Polyglotte débutant', description: 'Commencer 3 langues différentes', icon: '🌍', condition: { type: 'LANGUAGES', value: 3 } },
    ];

    for (const badge of badgesData) {
        await prisma.badge.upsert({
            where: { code: badge.code },
            update: badge,
            create: badge,
        });
    }

    // ── Content demo : cours d'anglais A1 ────────────────────
    const english = await prisma.language.findUnique({ where: { code: 'en' } });
    const levelA1 = await prisma.level.findUnique({ where: { code: 'A1' } });
    const french = await prisma.language.findUnique({ where: { code: 'fr' } });

    if (english && levelA1 && french) {
        const course = await prisma.course.upsert({
            where: { id: '00000000-0000-0000-0000-000000000001' },
            update: {},
            create: {
                id: '00000000-0000-0000-0000-000000000001',
                languageId: english.id,
                levelId: levelA1.id,
                title: 'Anglais A1 — Débutant',
                description: 'Cours d’introduction à l’anglais pour débutants.',
                order: 1,
                isPublished: true,
            },
        });

        const module1 = await prisma.module.upsert({
            where: { id: '00000000-0000-0000-0000-000000000010' },
            update: {},
            create: {
                id: '00000000-0000-0000-0000-000000000010',
                courseId: course.id,
                title: 'Se présenter',
                description: 'Apprendre à se présenter en anglais.',
                order: 1,
            },
        });

        const lesson1 = await prisma.lesson.upsert({
            where: { id: '00000000-0000-0000-0000-000000000100' },
            update: {},
            create: {
                id: '00000000-0000-0000-0000-000000000100',
                moduleId: module1.id,
                title: 'Hello, my name is...',
                description: 'Dire bonjour et se présenter.',
                order: 1,
                estimatedDuration: 8,
                isPublished: true,
                contents: {
                    create: [
                        { type: 'MARKDOWN', content: '# Hello!\n\n**Hello** = Bonjour', order: 1 },
                        { type: 'MARKDOWN', content: '**My name is John.** = Je m’appelle John.', order: 2 },
                    ],
                },
            },
        });

        // Vocabulary demo
        const wordApple = await prisma.vocabulary.upsert({
            where: { id: '00000000-0000-0000-0000-000000000200' },
            update: {},
            create: {
                id: '00000000-0000-0000-0000-000000000200',
                languageId: english.id,
                levelId: levelA1.id,
                word: 'apple',
                phonetic: '/ˈæpəl/',
                category: 'food',
                partOfSpeech: 'noun',
            },
        });

        await prisma.vocabularyTranslation.upsert({
            where: { vocabularyId_languageId: { vocabularyId: wordApple.id, languageId: french.id } },
            update: {},
            create: { vocabularyId: wordApple.id, languageId: french.id, translation: 'pomme' },
        });

        await prisma.vocabularyExample.create({
            data: {
                vocabularyId: wordApple.id,
                sentence: 'I eat an apple every morning.',
                translation: 'Je mange une pomme chaque matin.',
                order: 1,
            },
        });

        // Exercise demo — QCM
        await prisma.exercise.upsert({
            where: { id: '00000000-0000-0000-0000-000000000300' },
            update: {},
            create: {
                id: '00000000-0000-0000-0000-000000000300',
                lessonId: lesson1.id,
                type: ExerciseType.MULTIPLE_CHOICE,
                question: 'What does "apple" mean?',
                order: 1,
                options: {
                    create: [
                        { label: 'Orange', isCorrect: false, order: 1 },
                        { label: 'Pomme', isCorrect: true, order: 2 },
                        { label: 'Banane', isCorrect: false, order: 3 },
                        { label: 'Raisin', isCorrect: false, order: 4 },
                    ],
                },
            },
        });
    }

    console.log('✅ Seed terminé.');
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });