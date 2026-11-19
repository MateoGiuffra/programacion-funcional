# Genera pdf/04-funciones-estilo-cheat-sheet.pdf (A4 apaisado, B/N) desde funciones.cheat.txt
# Uso: python build_cheat.py [--hs RUTA/Defs.hs]
#   --hs: ademas escribe un modulo Haskell con TODAS las versiones ([E], [S], [C]) para verificar con GHC.
# Requiere: pymupdf y Edge o Chrome.
#
# Formato de funciones.cheat.txt:
#   # N. TITULO [|flow]   seccion (|flow = 2 columnas de bloques; sin flow = ancho completo con pares lado a lado)
#   ## nombre             bloque (una funcion o par de funciones)
#   -- texto              descripcion (cursiva), antes del primer marcador
#   [E] / [S] / [C]       codigo: EXPLICITA / CON ESQUEMA / unico (se compilan con --hs)
#   [X]                   codigo de ejemplo (no se compila)
#   [M] texto             comentario en cursiva entre filas
#   a ;; b ;; c           celdas que se alinean en columnas con las lineas vecinas
#   @@<texto>             linea de continuacion, indentada bajo la ultima celda de la linea anterior
import re, sys, os, html, pathlib, subprocess, tempfile, time
import fitz

HERE = pathlib.Path(__file__).resolve().parent
SRC = HERE / "funciones.cheat.txt"
OUT = HERE.parent / "pdf" / "04-funciones-estilo-cheat-sheet.pdf"
TITLE = "04 · Funciones estilo cheat-sheet"
BROWSERS = [r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            r"C:\Program Files\Google\Chrome\Application\chrome.exe"]
BROWSER = next(b for b in BROWSERS if os.path.exists(b))

BASE_PT = 8.6                 # tamano de codigo
CHAR_W = 0.55                 # ancho de caracter (em) de Consolas
WIDE_CHARS = 148              # caracteres que entran lado a lado (2 columnas) a BASE_PT
FLOW_CHARS = 74               # caracteres que entran en una columna del modo flow


def align(lines):
    """Alinea en columnas las lineas con ';;' consecutivas; resuelve '@@'."""
    out, i, start = [], 0, 0
    while i < len(lines):
        if ";;" in lines[i]:
            j = i
            while j < len(lines) and ";;" in lines[j]:
                j += 1
            rows = []
            for l in lines[i:j]:
                c = l.split(";;")
                rows.append([c[0].rstrip()] + [x.strip() for x in c[1:]])
            wid = {}
            for r in rows:
                for k, cell in enumerate(r[:-1]):
                    wid[k] = max(wid.get(k, 0), len(cell))
            for r in rows:
                s = ""
                for k, cell in enumerate(r):
                    if k < len(r) - 1:
                        s += cell.ljust(wid[k]) + " "
                    else:
                        start = len(s)
                        s += cell
                out.append(s.rstrip())
            i = j
        elif lines[i].startswith("@@"):
            out.append(" " * start + lines[i][2:])
            i += 1
        else:
            out.append(lines[i].rstrip())
            start = 0
            i += 1
    return out


def parse():
    secs, sec, blk, item = [], None, None, None
    for raw in SRC.read_text(encoding="utf-8").split("\n"):
        line = raw.rstrip()
        if line.startswith("# "):
            t = line[2:]
            flow = t.endswith("|flow")
            sec = {"title": t.replace("|flow", "").strip(), "flow": flow, "blocks": []}
            secs.append(sec); blk = item = None
        elif line.startswith("## "):
            blk = {"name": line[3:], "desc": [], "items": []}
            sec["blocks"].append(blk); item = None
        elif re.match(r"^\[([ESCXM])\]", line):
            k = line[1]
            rest = line[3:].strip()
            item = {"k": k, "lines": []}
            if k == "M":
                item["lines"] = [re.sub(r"^--\s*", "", rest)]
            blk["items"].append(item)
        elif line.startswith("-- ") and not blk["items"]:
            blk["desc"].append(line[3:])
        elif line.strip() == "":
            continue
        else:
            item["lines"].append(line)
    for s in secs:
        for b in s["blocks"]:
            for it in b["items"]:
                if it["k"] != "M":
                    it["lines"] = align(it["lines"])
    return secs


def esc(s):
    return html.escape(s, quote=False)


def inline(s):
    return re.sub(r"`([^`]+)`", r"<code>\1</code>", esc(s))


def pre(lines, cap, k=""):
    n = max((len(l) for l in lines), default=1)
    style = ""
    if n > cap:
        style = f' style="font-size:{max(7.2, BASE_PT * cap / n):.2f}pt"'
    return f'<pre{style}>{esc(chr(10).join(lines))}</pre>'


def rows_of(items):
    """Agrupa E/S en filas: [E] abre fila, [S] se une a la fila si le falta; [C]/[X]/[M] van solos."""
    rows = []
    for it in items:
        k = it["k"]
        if k == "E":
            rows.append({"E": it, "S": None})
        elif k == "S":
            if rows and rows[-1].get("E") is not None and rows[-1]["S"] is None and "C" not in rows[-1]:
                rows[-1]["S"] = it
            else:
                rows.append({"E": None, "S": it})
        else:
            rows.append({k: it})
    return rows


def render(secs):
    h = []
    warns = []
    for s in secs:
        h.append(f'<section class="sec{" flow" if s["flow"] else ""}"><div class="bar">{esc(s["title"])}</div>')
        h.append('<div class="blocks">')
        for b in s["blocks"]:
            h.append('<div class="blk">')
            h.append(f'<h3>{inline(b["name"])}</h3>')
            if b["desc"]:
                h.append(f'<p class="d">-- {inline(" ".join(b["desc"]))}</p>')
            first_pair = True
            for r in rows_of(b["items"]):
                if "M" in r:
                    h.append(f'<p class="d">-- {inline(r["M"]["lines"][0])}</p>')
                elif "C" in r or "X" in r:
                    it = r.get("C") or r.get("X")
                    cap = FLOW_CHARS if s["flow"] else WIDE_CHARS
                    n = max(len(l) for l in it["lines"])
                    if n > cap: warns.append((b["name"], n, cap))
                    h.append(f'<div class="one">{pre(it["lines"], cap)}</div>')
                else:
                    E, S = r["E"], r["S"]
                    lab = first_pair
                    first_pair = False
                    if s["flow"]:
                        for it, name in ((E, "EXPLÍCITA"), (S, "CON ESQUEMA")):
                            if it:
                                n = max(len(l) for l in it["lines"])
                                if n > FLOW_CHARS: warns.append((b["name"], n, FLOW_CHARS))
                                h.append(f'<div class="one">' + (f'<div class="lab">-- {name}</div>' if lab else "")
                                         + pre(it["lines"], FLOW_CHARS) + '</div>')
                    else:
                        le = max((len(l) for l in E["lines"]), default=0) if E else 0
                        ls = max((len(l) for l in S["lines"]), default=0) if S else 0
                        tot = le + ls + 4
                        cap_each = WIDE_CHARS * 0.5
                        # fr proporcionales al largo; fuente chica si no entra
                        half = WIDE_CHARS // 2
                        fr_e, fr_s = (1, 1) if (le <= half and ls <= half) else (max(le, 24), max(ls, 24))
                        if (le <= half and ls <= half): tot = 0
                        scale = BASE_PT
                        if tot > WIDE_CHARS:
                            scale = max(7.2, BASE_PT * WIDE_CHARS / tot)
                            if scale <= 7.2 and tot * scale / BASE_PT > WIDE_CHARS + 2:
                                warns.append((b["name"], tot, WIDE_CHARS))
                        st = f' style="grid-template-columns:{fr_e}fr {fr_s}fr;font-size:{scale:.2f}pt"'
                        cell = lambda it, name: (f'<div>' + (f'<div class="lab">-- {name}</div>' if lab else "")
                                                 + (f'<pre>{esc(chr(10).join(it["lines"]))}</pre>' if it else "") + '</div>')
                        h.append(f'<div class="row"{st}>{cell(E, "EXPLÍCITA")}{cell(S, "CON ESQUEMA")}</div>')
            h.append('</div>')
        h.append('</div></section>')
    for w in warns:
        print("AVISO linea larga:", w)
    return "\n".join(h)


CSS = r"""
@page { size: A4 landscape; margin: 1.2cm 1.3cm 1.7cm 1.3cm; }
* { color:#000 !important; box-shadow:none !important; }
html, body { background:#fff !important; }
body { font-family:"Segoe UI",Arial,sans-serif; font-size:9pt; margin:0; }
h1 { font-family:Consolas,"Courier New",monospace; font-size:15pt; margin:0 0 2pt; }
.sub { font-size:8.4pt; font-style:italic; margin:0 0 7pt; }
.bar { border:1pt solid #000; border-left:5pt solid #000; background:#e8e8e8 !important; font-family:Consolas,"Courier New",monospace;
       font-weight:bold; font-size:10.5pt; padding:2.5pt 7pt; margin:9pt 0 5pt; break-after:avoid; }
.sec { break-before:auto; }
.flow .blocks { column-count:2; column-gap:18pt; column-rule:0.6pt solid #000; }
.blk { break-inside:avoid; margin:0 0 5pt; }
h3 { font-family:Consolas,"Courier New",monospace; font-size:9.3pt; font-weight:bold; margin:0 0 1.5pt;
     border-bottom:0.6pt solid #000; padding-bottom:0.5pt; break-after:avoid; }
h3 code { font-weight:bold; }
p.d { font-style:italic; font-size:8.3pt; line-height:1.25; margin:1.5pt 0 2.5pt; }
code { font-family:Consolas,"Courier New",monospace; font-size:8.2pt; font-style:normal; }
.lab { font-family:Consolas,"Courier New",monospace; font-weight:bold; font-style:italic; font-size:8pt; margin:2pt 0 0.5pt; }
pre { font-family:Consolas,"Courier New",monospace; font-size:8.6pt; line-height:1.22; margin:0 0 3pt; white-space:pre; }
.row { display:grid; column-gap:14pt; }
.row > div { min-width:0; }
.one { margin:0; }
"""


def build(secs):
    body = render(secs)
    head = ('<h1>FUNCIONES TÍPICAS — Programación Funcional (UNQ)</h1>'
            '<p class="sub">EXPLÍCITA = recursión escrita a mano. CON ESQUEMA = la misma función con foldr / recr / foldT '
            '(nombres primados: f\'). Todas las versiones fueron compiladas con GHC y comparadas entre sí y con el Prelude.</p>')
    page = f'<!doctype html><html lang="es"><head><meta charset="utf-8"><title>{TITLE}</title><style>{CSS}</style></head><body>{head}{body}</body></html>'
    tmp = pathlib.Path(tempfile.gettempdir()) / "cheat04.html"
    tmp.write_text(page, encoding="utf-8")
    raw = OUT.with_suffix(".raw.pdf")
    OUT.parent.mkdir(exist_ok=True)
    if raw.exists(): raw.unlink()
    subprocess.run([BROWSER, "--headless", "--disable-gpu", "--no-pdf-header-footer",
                    f"--user-data-dir={tempfile.mkdtemp(prefix='pfprof')}", f"--print-to-pdf={raw}", tmp.as_uri()],
                   check=True, capture_output=True, timeout=180)
    for _ in range(120):
        if raw.exists() and raw.stat().st_size > 0: break
        time.sleep(0.5)
    if not raw.exists(): sys.exit("Fallo la impresion del navegador")
    d = fitz.open(raw); n = len(d)
    for i, p in enumerate(d):
        r = p.rect
        p.draw_line((37, r.height - 38), (r.width - 37, r.height - 38), color=(0, 0, 0), width=0.5)
        p.insert_text((37, r.height - 26), f"{TITLE}  -  Programación Funcional UNQ", fontsize=8, fontname="helv", color=(0, 0, 0))
        t = f"Página {i+1} de {n}"
        p.insert_text((r.width - 37 - fitz.get_text_length(t, "helv", 8), r.height - 26), t, fontsize=8, fontname="helv", color=(0, 0, 0))
    d.save(OUT); d.close(); raw.unlink()
    print(OUT, n, "páginas")


def write_hs(secs, path):
    names = set()
    code = []
    for s in secs:
        for b in s["blocks"]:
            for it in b["items"]:
                if it["k"] in "ESC":
                    code.append("\n".join(it["lines"]))
                    for l in it["lines"]:
                        m = re.match(r"^([a-z]\w*)\b", l)
                        if m and m.group(1) != "data" and not m.group(1).endswith("'"): names.add(m.group(1))
    hide = ", ".join(sorted(names))
    hs = f"module Defs where\nimport Prelude hiding ({hide})\n\n" + "\n".join(code) + "\n"
    pathlib.Path(path).write_text(hs, encoding="utf-8")
    print("hs:", path)


if __name__ == "__main__":
    secs = parse()
    if "--hs" in sys.argv:
        write_hs(secs, sys.argv[sys.argv.index("--hs") + 1])
    else:
        build(secs)
