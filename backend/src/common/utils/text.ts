/**
 * Utilitaires de comparaison de texte pour la correction d'exercices.
 * - Normalisation (casse, accents, espaces, ponctuation)
 * - Distance de Levenshtein et similarité
 * - Matching flou tolérant (utilisé pour les traductions)
 */

/** Normalise : NFC, minuscules, trim, espaces multiples → 1, ponctuation finale retirée. */
export function normalizeText(input: string, options: { stripAccents?: boolean } = {}): string {
    let s = input.normalize('NFC').toLowerCase().trim();
    if (options.stripAccents) {
        s = s.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    }
    // Espaces insécables, tabulations → espace simple
    s = s.replace(/[\s\u00A0]+/g, ' ');
    // Retire la ponctuation de fin (.,!?;:…)
    s = s.replace(/[.,!?;:…]+$/u, '');
    return s;
}

/** Normalise une séquence de mots (Word Order) : mêmes règles + jointure. */
export function normalizeWordSequence(words: string[]): string {
    return normalizeText(words.join(' '));
}

/** Distance de Levenshtein (itératif, O(n·m)). */
export function levenshtein(a: string, b: string): number {
    if (a === b) return 0;
    if (a.length === 0) return b.length;
    if (b.length === 0) return a.length;

    let prev = new Array<number>(b.length + 1);
    let curr = new Array<number>(b.length + 1);

    for (let j = 0; j <= b.length; j++) prev[j] = j;

    for (let i = 1; i <= a.length; i++) {
        curr[0] = i;
        for (let j = 1; j <= b.length; j++) {
            const cost = a[i - 1] === b[j - 1] ? 0 : 1;
            curr[j] = Math.min(
                prev[j] + 1,      // suppression
                curr[j - 1] + 1,  // insertion
                prev[j - 1] + cost, // substitution
            );
        }
        [prev, curr] = [curr, prev];
    }
    return prev[b.length];
}

/** Similarité [0..1] basée sur Levenshtein. */
export function similarity(a: string, b: string): number {
    const maxLen = Math.max(a.length, b.length);
    if (maxLen === 0) return 1;
    return 1 - levenshtein(a, b) / maxLen;
}

/**
 * Égalité floue : renvoie true si les chaînes normalisées sont identiques
 * OU si la similarité dépasse `threshold` (par défaut 0.85).
 */
export function fuzzyEquals(a: string, b: string, threshold = 0.85): boolean {
    const na = normalizeText(a, { stripAccents: true });
    const nb = normalizeText(b, { stripAccents: true });
    if (na === nb) return true;
    return similarity(na, nb) >= threshold;
}

/** Découpe une chaîne en mots normalisés (pour Word Order tolérant). */
export function tokenize(text: string): string[] {
    return normalizeText(text, { stripAccents: true })
        .split(' ')
        .filter((w) => w.length > 0);
}