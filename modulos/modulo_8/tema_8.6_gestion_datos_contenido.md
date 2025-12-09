# Tema 8.6: Gestión de Datos (Excel no muerde)

## Introducción: El Entrenador Data-Driven

Si tienes 20 atletas y usas WhatsApp para mandar rutinas, vas a colapsar.
Si usas papel, los datos mueren en el papel.
Necesitas un **sistema centralizado**. Excel (o Google Sheets) es la herramienta más poderosa y flexible del mundo, si sabes usarla.

## 1. Estructura de Base de Datos

No hagas una hoja por atleta desligada de todo.
Crea una "Sábana Maestra" (Master Sheet).

* **Columnas**: Fecha | Atleta | Ejercicio | Series | Reps | Peso | RPE | Tonelaje (Fórmula).
* **Ventaja**: Con una Tabla Dinámica (Pivot Table), puedes filtrar por "Juan" y ver su progreso en "Sentadilla" de los últimos 3 años en un gráfico instantáneo.

## 2. Visualización (Dashboards)

El cliente no quiere ver una tabla con 1000 números. Quiere ver un **Gráfico de Línea** que sube.

* **El Dashboard del Cliente**: Una pestaña bonita con 3 gráficas clave:
    1. Evolución del Peso Corporal.
    2. Evolución del 1RM Estimado (Fuerza).
    3. Cumplimiento (Semáforo Verde/Rojo de asistencia).
* **Efecto**: Refuerza positivo. "Mira Juan, aunque te ves igual en el espejo, tu fuerza ha subido un 20%. Vamos bien".

## 3. Automatización Básica

Deja de calcular porcentajes a mano.

* **Fórmula RM**: Si pones el 1RM en una celda (B1 = 100kg), la rutina se auto-rellena.
  * Semana 1: `=B1*0.70` (70kg).
  * Semana 2: `=B1*0.75` (75kg).
* Si el atleta mejora su RM, cambias B1 a 105kg y **TODA** la programación de 12 semanas se actualiza sola. Magia.

## 4. Google Forms como Input

No pidas que te manden un PDF relleno. Es un dolor vaciar eso a Excel.

1. Crea un Google Form: "¿Qué ejercicio hiciste?", "¿Cuánto peso?", "¿RPE?".
2. El atleta lo rellena en el móvil al terminar.
3. Las respuestas van automáticas a tu Google Sheet.
4. Tu gráfica se actualiza sola.
**Tiempo invertido por ti**: 0 minutos.

## Resumen

No necesitas ser programador.
Con `SUMA`, `PROMEDIO`, `MAX` y un `GRÁFICO`, eres mejor que el 90% de entrenadores que van a ciegas.
Los datos te dan autoridad profesional.
