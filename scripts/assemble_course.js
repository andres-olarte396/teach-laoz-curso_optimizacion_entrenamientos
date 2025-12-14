
const fs = require('fs');
const path = require('path');

const coursePath = path.join(__dirname, '..');
const outputPath = path.join(coursePath, 'CURSO_COMPLETO.md');
const modulesDir = path.join(coursePath, 'modulos');

const titles = [
    "Preconceptos y Fundamentos Científicos",
    "Biomecánica Aplicada y Evaluación Avanzada",
    "Fisiología del Esfuerzo y Adaptación Muscular",
    "Selección y Optimización de Ejercicios",
    "Diseño de Programas y Periodización Avanzada",
    "Nutrición y Suplementación",
    "Psicología del Coaching",
    "Métodos Avanzados de Entrenamiento",
    "Tecnología y Data Analytics",
    "Recuperación y Readaptación"
];

let finalContent = `# CURSO COMPLETO: OPTIMIZACIÓN DE ENTRENAMIENTOS (2025)\n\nGenerado el ${new Date().toISOString()}\n\n---\n\n`;

try {
    for (let i = 0; i <= 9; i++) {
        const modDir = path.join(modulesDir, `modulo_${i}`);
        if (fs.existsSync(modDir)) {
            const title = titles[i] || `Módulo ${i}`;
            console.log(`Processing Módulo ${i}: ${title}`);
            finalContent += `## Módulo ${i}: ${title}\n\n`;

            const files = fs.readdirSync(modDir).sort();
            const contentFiles = files.filter(f => f.endsWith('_contenido.md'));

            for (const file of contentFiles) {
                // tema_1.1_slug_contenido.md
                const match = file.match(/tema_(\d+\.\d+)_(.+)_contenido\.md/);
                if (match) {
                    const topicNum = match[1];
                    const slug = match[2];
                    
                    const contentPath = path.join(modDir, file);
                    let content = fs.readFileSync(contentPath, 'utf8');
                    
                    // Extract title from content
                    const titleMatch = content.match(/^#+\s*(.+)/);
                    const topicTitle = titleMatch ? titleMatch[1] : `Tema ${topicNum}`;

                    finalContent += `### ${topicTitle}\n\n`;
                    finalContent += `#### 📖 Contenido Teórico\n\n${content}\n\n---\n\n`;

                    // Exercises
                    const exFile = `tema_${topicNum}_${slug}_ejercicios.md`;
                    const exPath = path.join(modDir, exFile);
                    if (fs.existsSync(exPath)) {
                        const exContent = fs.readFileSync(exPath, 'utf8');
                        finalContent += `#### 💻 Ejercicios Prácticos\n\n${exContent}\n\n---\n\n`;
                    }

                    // Evaluation
                    const evFile = `tema_${topicNum}_${slug}_evaluacion.md`;
                    const evPath = path.join(modDir, evFile);
                    if (fs.existsSync(evPath)) {
                        const evContent = fs.readFileSync(evPath, 'utf8');
                        finalContent += `#### 🎯 Evaluación\n\n${evContent}\n\n---\n\n`;
                    }
                }
            }
        }
    }

    fs.writeFileSync(outputPath, finalContent, 'utf8');
    console.log(`Successfully created ${outputPath}`);
} catch (err) {
    console.error('Error:', err);
    process.exit(1);
}
