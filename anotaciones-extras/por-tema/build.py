# Regenera los 3 .md y los 3 PDFs (B/N, A4) a partir de ../guia-parciales-1.md
# Uso: python build.py   (requiere: markdown, pymupdf, Edge o Chrome)
import re, subprocess, sys, tempfile, os, pathlib
import markdown, fitz

HERE = pathlib.Path(__file__).resolve().parent
SRC = HERE.parent / "guia-parciales-1.md"
PDF = HERE / "pdf"; PDF.mkdir(exist_ok=True)
BROWSERS = [r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            r"C:\Program Files\Google\Chrome\Application\chrome.exe"]
BROWSER = next(b for b in BROWSERS if os.path.exists(b))

lines = SRC.read_text(encoding="utf-8").split("\n")
def L(a, b): return "\n".join(lines[a-1:b]).strip("\n") + "\n"   # 1-based inclusive

# --- split automatico por encabezados "## " de la guia ---
# MAPA seccion -> documento (por numero de encabezado "## N."; "Resumen" se parte aparte).
# Si se agrega una seccion numerada nueva a la guia, agregarla aca. Sin entrada => error.
SECCION_A_DOC = {0: 1, 1: 1, 2: 1, 3: 1, 4: 2, 5: 3, 6: 1}
RENUM_DOC1 = {6: 4}          # sintaxis pasa de 6 a 4 dentro del doc 01
text = "\n".join(lines)
parts = re.split(r"(?m)^(?=## )", text)
secs = {1: [], 2: [], 3: []}
resumen = None
for p in parts[1:]:
    h = p.split("\n", 1)[0]
    m = re.match(r"## (\d+)\.", h)
    if m:
        n = int(m.group(1))
        if n not in SECCION_A_DOC: sys.exit(f"Seccion sin mapa: {h}")
        d = SECCION_A_DOC[n]
        if d == 1 and n in RENUM_DOC1: p = p.replace(f"## {n}.", f"## {RENUM_DOC1[n]}.", 1)
        if d != 1: p = re.sub(r"^## \d+\. ", "## ", p)
        secs[d].append(p.strip("\n") + "\n")
    elif h.startswith("## Resumen"):
        resumen = p
    else:
        sys.exit(f"Encabezado sin mapa: {h}")
# Resumen: linea "**Codigo:**" -> doc 01; el resto (demo en 7 lineas) -> doc 02
rl = resumen.split("\n")[1:]
codigo = [l for l in rl if l.startswith("**Código:**")]
demo = [l for l in rl if l not in codigo]
doc1 = ("# 01 - Tips e implementación (Programación Funcional, UNQ)\n\n## Resumen\n\n"
        + "\n".join(codigo).replace("chequeá sintaxis (§1)", "chequeá (§1 y §4)")
        + "\nFunciones de uso frecuente: ver documento 03. Demostraciones: ver documento 02.\n\n" + "\n".join(secs[1]))
doc2 = ("# 02 - Demostraciones (Programación Funcional, UNQ)\n\n## Resumen: demo en 7 líneas\n\n"
        + "\n".join(demo).replace("**Demo en 7 líneas:**", "").strip("\n") + "\n\n" + "\n".join(secs[2]))
doc3 = "# 03 - Funciones típicas (Programación Funcional, UNQ)\n\n" + "\n".join(secs[3])

# --- referencias cruzadas que cambian de documento ---
def sub(doc, old, new):
    if old not in doc: print("AVISO: referencia no encontrada:", old)
    return doc.replace(old, new)
doc1 = sub(doc1, "(ver `subtract`, §5)", "(ver `subtract`, documento 03 Funciones típicas)")
doc3 = sub(doc3, "el `case` de §3", "el `case` de la forma «fusionar secuencias» (documento 01, §3)")
doc3 = sub(doc3, "a mano un caso base compartido (§2)", "a mano un caso base compartido (documento 01, §2)")

docs = [("01-tips-e-implementacion", "01 · Tips e implementación", doc1),
        ("02-demostraciones", "02 · Demostraciones", doc2),
        ("03-funciones-tipicas", "03 · Funciones típicas", doc3)]

CSS = r"""
@page { size: A4; margin: 1.6cm 1.7cm 2.0cm 1.7cm; }
* { color:#000 !important; background:transparent !important; box-shadow:none !important;
    -webkit-print-color-adjust: economy; }
html { background:#fff !important; }
body { font-family: "Segoe UI", Arial, sans-serif; font-size:10pt; line-height:1.32; margin:0; }
h1 { font-size:17pt; border-bottom:2px solid #000; padding-bottom:3pt; margin:0 0 8pt; }
h2 { font-size:13.5pt; border-bottom:1px solid #000; margin:13pt 0 5pt; break-after:avoid; }
h3 { font-size:11.5pt; margin:10pt 0 4pt; break-after:avoid; }
p { margin:4pt 0; } ul,ol { margin:3pt 0 3pt 0; padding-left:17pt; } li { margin:1.5pt 0; }
code { font-family: Consolas, "Courier New", monospace; font-size:9pt; }
pre { border:0.8pt solid #000; background:#f2f2f2 !important; padding:4pt 6pt; margin:5pt 0;
      white-space:pre-wrap; overflow-wrap:anywhere; break-inside:avoid; }
pre code { font-size:8.5pt; line-height:1.28; }
table { border-collapse:collapse; width:100%; margin:5pt 0; table-layout:auto; font-size:9.3pt; }
th, td { border:0.8pt solid #000; padding:2pt 4pt; text-align:left; vertical-align:top; overflow-wrap:anywhere; }
th { font-weight:bold; background:#e8e8e8 !important; border-bottom:1.6pt solid #000; }
td code, th code { font-size:8.6pt; }
tr { break-inside:avoid; }
td:first-child { overflow-wrap:normal; }
table.big { break-inside:auto; }
"""

def render(name, title, md):
    (HERE / f"{name}.md").write_text(md, encoding="utf-8")
    # lista inmediatamente despues de un parrafo (sin linea en blanco): python-markdown no la reconoce
    md2 = re.sub(r"(?m)^(?!\s*(?:- |\* |\d+\. |[|`#>]))(\S[^\n]*)\n(?=\s*(?:- |\* |\d+\. ))", r"\1\n\n", md)
    html = markdown.markdown(md2, extensions=["fenced_code", "tables"]).replace(chr(92) + "|", "|")
    page = f'<!doctype html><html lang="es"><head><meta charset="utf-8"><title>{title}</title><style>{CSS}</style></head><body>{html}</body></html>'
    tmp = pathlib.Path(tempfile.gettempdir()) / f"{name}.html"
    tmp.write_text(page, encoding="utf-8")
    raw = PDF / f"{name}.raw.pdf"; out = PDF / f"{name}.pdf"
    subprocess.run([BROWSER, "--headless", "--disable-gpu", "--no-pdf-header-footer", f"--user-data-dir={tempfile.mkdtemp(prefix='pfprof')}",
                    f"--print-to-pdf={raw}", tmp.as_uri()], check=True, capture_output=True, timeout=120)
    import time
    for _ in range(120):
        if raw.exists() and raw.stat().st_size > 0: break
        time.sleep(0.5)
    if not raw.exists(): sys.exit("Fallo la impresion del navegador")
    if not raw.exists(): sys.exit("Falló la impresión del navegador")
    d = fitz.open(raw); n = len(d)
    for i, p in enumerate(d):
        r = p.rect
        p.insert_text((48, r.height - 30), f"{title}  -  Programación Funcional UNQ", fontsize=8, fontname="helv", color=(0,0,0))
        t = f"Página {i+1} de {n}"
        p.insert_text((r.width - 48 - fitz.get_text_length(t, "helv", 8), r.height - 30), t, fontsize=8, fontname="helv", color=(0,0,0))
        p.draw_line((48, r.height - 40), (r.width - 48, r.height - 40), color=(0,0,0), width=0.5)
    d.save(out); d.close(); raw.unlink()
    print(name, n, "páginas")

for n, t, m in docs: render(n, t, m)
