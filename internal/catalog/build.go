package catalog

import (
	"encoding/json"
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

type BuildOptions struct{ ConfigPath, ArchiveDir, RecordsDir, DocsDir string }

type pageData struct {
	Config     Config
	Records    []Record
	Record     Record
	Counts     map[string]int
	Credits    []Credit
	Groups     []RecordGroup
	IndexTitle string
	IndexIntro string
}

func Build(opts BuildOptions) error {
	cfg, err := LoadConfig(opts.ConfigPath)
	if err != nil {
		return err
	}
	recs, err := loadRecords(opts.RecordsDir)
	if err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Join(opts.DocsDir, "scripts"), 0o755); err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Join(opts.DocsDir, "assets"), 0o755); err != nil {
		return err
	}
	for _, pair := range []struct{ p, c string }{{"assets/style.css", styleCSS}, {"assets/app.js", appJS}, {".nojekyll", ""}} {
		if err := os.WriteFile(filepath.Join(opts.DocsDir, pair.p), []byte(pair.c), 0o644); err != nil {
			return err
		}
	}
	counts := map[string]int{"scripts": len(recs), "sources": len(cfg.Sources), "credits": len(cfg.Credits)}
	if err := render(filepath.Join(opts.DocsDir, "index.html"), indexTemplate, pageData{Config: cfg, Records: recs, Counts: counts, Credits: cfg.Credits}); err != nil {
		return err
	}
	if err := render(filepath.Join(opts.DocsDir, "credits.html"), creditsTemplate, pageData{Config: cfg, Records: recs, Counts: counts, Credits: cfg.Credits}); err != nil {
		return err
	}
	if err := render(filepath.Join(opts.DocsDir, "official.html"), officialTemplate, pageData{Config: cfg, Records: recs, Counts: counts, Credits: cfg.Credits}); err != nil {
		return err
	}
	if err := render(filepath.Join(opts.DocsDir, "about.html"), aboutTemplate, pageData{Config: cfg, Records: recs, Counts: counts, Credits: cfg.Credits}); err != nil {
		return err
	}
	for _, page := range []struct {
		name, title, intro string
		groups []RecordGroup
	}{
		{"az.html", "A–Z script index", "Every vendored ASH script, alphabetically grouped and hyperlinked to its record page.", GroupsAZ(recs)},
		{"classifications.html", "Classification index", "Browse the catalog by source-derived script class, with static behavior shown on every entry.", GroupsClassification(recs)},
		{"sources.html", "Source repository index", "Browse vendored scripts by their original GitHub repository.", GroupsSource(recs)},
		{"authors.html", "Author / player index", "Browse scripts by detected or configured author attribution.", GroupsAuthor(recs)},
		{"years.html", "Release-year index", "Browse scripts by earliest detected header year; unknown dates remain explicitly unknown.", GroupsYear(recs)},
	} {
		if err := render(filepath.Join(opts.DocsDir, page.name), groupedIndexTemplate, pageData{Config: cfg, Records: recs, Counts: counts, Credits: cfg.Credits, Groups: page.groups, IndexTitle: page.title, IndexIntro: page.intro}); err != nil {
			return err
		}
	}
	if err := render(filepath.Join(opts.DocsDir, "third-party.html"), thirdPartyTemplate, pageData{Config: cfg, Counts: counts}); err != nil {
		return err
	}
	if err := render(filepath.Join(opts.DocsDir, "license.html"), licenseTemplate, pageData{Config: cfg, Counts: counts}); err != nil {
		return err
	}
	for _, r := range recs {
		if err := render(filepath.Join(opts.DocsDir, "scripts", r.ID+".html"), scriptTemplate, pageData{Config: cfg, Record: r, Counts: counts}); err != nil {
			return err
		}
	}
	b, _ := json.Marshal(recs)
	if err := os.WriteFile(filepath.Join(opts.DocsDir, "assets", "catalog.json"), b, 0o644); err != nil {
		return err
	}
	return nil
}

func loadRecords(dir string) ([]Record, error) {
	ents, err := os.ReadDir(dir)
	if errorsIsNotExist(err) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	out := []Record{}
	for _, e := range ents {
		if e.IsDir() || !strings.HasSuffix(e.Name(), ".json") || strings.HasPrefix(e.Name(), "blocked--") {
			continue
		}
		b, err := os.ReadFile(filepath.Join(dir, e.Name()))
		if err != nil {
			return nil, err
		}
		var r Record
		if json.Unmarshal(b, &r) == nil && r.ID != "" {
			out = append(out, r)
		}
	}
	sort.Slice(out, func(i, j int) bool { return strings.ToLower(out[i].Title) < strings.ToLower(out[j].Title) })
	return out, nil
}
func errorsIsNotExist(err error) bool { return err != nil && os.IsNotExist(err) }

func render(path, tpl string, data any) error {
	f := template.FuncMap{
		"join": strings.Join,
		"relArchive": func(s string) string { return "../" + strings.TrimPrefix(filepath.ToSlash(s), "archive/") },
		"scriptURL": func(id string) string { return "scripts/" + id + ".html" },
		"lower": strings.ToLower,
		"slug": func(s string) string { return safe(strings.ToLower(s)) },
	}
	t, err := template.New("p").Funcs(f).Parse(tpl)
	if err != nil {
		return err
	}
	var b strings.Builder
	if err := t.Execute(&b, data); err != nil {
		return err
	}
	return os.WriteFile(path, []byte(b.String()), 0o644)
}

const head = `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="color-scheme" content="dark"><title>{{.Config.UnofficialName}} · {{.Config.Name}}</title><link rel="stylesheet" href="{{if .Record.ID}}../{{end}}assets/style.css"></head><body><header class="top"><a class="brand" href="{{if .Record.ID}}../{{end}}index.html"><i></i><span><b>ask-wiki</b><small>master-ash-catalog</small></span></a><nav><a href="{{if .Record.ID}}../{{end}}index.html">Scripts</a><a href="{{if .Record.ID}}../{{end}}az.html">A–Z</a><a href="{{if .Record.ID}}../{{end}}classifications.html">Classes</a><a href="{{if .Record.ID}}../{{end}}sources.html">Sources</a><a href="{{if .Record.ID}}../{{end}}authors.html">Authors</a><a href="{{if .Record.ID}}../{{end}}credits.html">Credits</a><a href="{{if .Record.ID}}../{{end}}official.html">Refs</a><a href="{{if .Record.ID}}../{{end}}third-party.html">Third-party</a><a href="{{if .Record.ID}}../{{end}}license.html">License</a></nav></header><main class="shell">`
const foot = `</main><footer><span><b>Archive warning:</b> review scripts before running · <a href="{{if .Record.ID}}../{{end}}third-party.html">Third-Party Scripts and Disclaimer</a></span><span>Community catalog · unofficial · Oxide Ledger</span></footer><script src="{{if .Record.ID}}../{{end}}assets/app.js"></script></body></html>`

const indexTemplate = head + `<section class="hero"><div><p class="eyebrow">STATIC ASH COMPENDIUM / GO-BUILT</p><h1>Scripts with receipts.</h1><p class="lede">A provenance-first, hyper-indexed static wiki for KoLmafia <code>.ash</code> automation. Search snapshots, classifications, authors, functions, eras, installability and behavior surfaces without pretending historical scripts are current or safe.</p></div><aside class="meter"><b>{{index .Counts "scripts"}}</b><span>licensed script snapshots</span><b>{{index .Counts "sources"}}</b><span>configured source channels</span></aside></section><nav class="browse-strip" aria-label="Wiki indexes"><a href="az.html"><b>A–Z</b><span>alphabetical script index</span></a><a href="classifications.html"><b>CLASS</b><span>script classification</span></a><a href="sources.html"><b>SOURCE</b><span>repository index</span></a><a href="authors.html"><b>AUTHOR</b><span>credit index</span></a><a href="years.html"><b>YEAR</b><span>release-era index</span></a></nav><section class="searchbar"><label>Search the catalog<input id="q" type="search" placeholder="BatBrain, relay, familiar, choice, ascension…" autocomplete="off"></label><div id="count">{{index .Counts "scripts"}} records</div></section><section class="cards" id="cards">{{range .Records}}<article class="script-card" data-search="{{lower .Title}} {{lower .Author}} {{lower .Player}} {{lower .Classification}} {{lower .Description}} {{lower (join .Keywords.Key " ")}} {{lower (join .Keywords.Sub " ")}} {{lower (join .Keywords.Meta " ")}} {{lower (join .Functions " ")}}"><div class="card-top"><span>{{.Classification}}</span><span>{{.Behavior.Class}}</span></div><h2><a href="{{scriptURL .ID}}">{{.Title}}</a></h2><p class="muted">{{if .Author}}{{.Author}}{{else}}author unknown{{end}} · {{if .Year}}{{.Year}}{{else}}year ?{{end}}</p><p class="card-desc">{{.Description}}</p><div class="tags">{{range .Keywords.Key}}<b>{{.}}</b>{{end}}{{range .Keywords.Sub}}<span>{{.}}</span>{{end}}</div><div class="hash">sha256 {{slice .SHA256 0 12}}</div></article>{{else}}<article class="empty"><h2>Catalog scaffold is ready.</h2><p>Run the sync workflow to populate licensed source snapshots. Sources with no detected redistribution license remain metadata-only.</p></article>{{end}}</section>` + foot

const scriptTemplate = head + `<article class="detail"><p class="eyebrow">SCRIPT RECORD / {{.Record.Behavior.Class}}</p><h1>{{.Record.Title}}</h1><p class="lede">{{.Record.Description}}</p><section class="classification-strip"><div><small>CLASSIFICATION</small><strong>{{.Record.Classification}}</strong></div><div><small>BEHAVIOR</small><strong>{{.Record.Behavior.Class}}</strong></div><div><small>AUTHOR / PLAYER</small><strong>{{if .Record.Author}}{{.Record.Author}}{{else}}unknown{{end}}{{if .Record.Player}} / {{.Record.Player}}{{end}}</strong></div></section>{{if .Record.Install.Available}}<section class="command-panel"><header><span>KoLmafia gCLI / repository install</span><small>This checkout installs the source project containing this script; it may install sibling files too.</small></header><div class="command-row"><div><small>CHECKOUT</small><code>{{.Record.Install.Checkout}}</code></div><button type="button" data-copy="{{.Record.Install.Checkout}}">COPY</button></div><div class="command-row"><div><small>DELETE</small><code>{{.Record.Install.Delete}}</code></div><button type="button" data-copy="{{.Record.Install.Delete}}">COPY</button></div></section>{{else}}<section class="command-panel unavailable"><header><span>KoLmafia gCLI / direct checkout not advertised</span><small>{{.Record.Install.Reason}}</small></header></section>{{end}}<section class="ledger"><div><small>SOURCE</small><a href="{{.Record.RepositoryURL}}">{{.Record.RepositoryURL}}</a></div><div><small>PATH</small><code>{{.Record.RepositoryPath}}</code></div><div><small>AUTHOR</small><strong>{{if .Record.Author}}{{.Record.Author}}{{else}}unknown{{end}}</strong></div>{{if .Record.Player}}<div><small>PLAYER</small><strong>{{.Record.Player}}</strong></div>{{end}}{{if .Record.Year}}<div><small>YEAR</small><strong>{{.Record.Year}}</strong></div>{{end}}{{if .Record.Version}}<div><small>VERSION</small><strong>{{.Record.Version}}</strong></div>{{end}}{{if .Record.ProvenanceURL}}<div><small>PROVENANCE</small><a href="{{.Record.ProvenanceURL}}">{{.Record.ProvenanceURL}}</a></div>{{end}}<div><small>COMMIT</small><code>{{.Record.Commit}}</code></div><div><small>SHA256</small><code>{{.Record.SHA256}}</code></div><div><small>LICENSE</small><strong>{{.Record.License.Name}} / {{.Record.License.Status}}</strong></div><div><small>IMPORT-SAFE?</small><strong>{{.Record.Behavior.ImportSafe}} (static heuristic)</strong></div></section><section class="cols"><div class="panel"><h2>3 / 6 / 12 index</h2><h3>KEY</h3><div class="tags key">{{range .Record.Keywords.Key}}<b>{{.}}</b>{{end}}</div><h3>SUB</h3><div class="tags">{{range .Record.Keywords.Sub}}<span>{{.}}</span>{{end}}</div><h3>META</h3><div class="tags meta">{{range .Record.Keywords.Meta}}<i>{{.}}</i>{{end}}</div></div><div class="panel"><h2>Behavior surface</h2><p class="muted">Static text scan only. Review the script before execution.</p><ul>{{range .Record.Behavior.Signals}}<li>{{.}}</li>{{else}}<li>No common mutation primitive detected by the lightweight scanner.</li>{{end}}</ul><h3>Imports</h3><code class="wrap">{{join .Record.Imports " · "}}</code></div></section><section class="cols"><div class="panel"><h2>Functions</h2><div class="function-list">{{range .Record.Functions}}<code>{{.}}</code>{{else}}<span class="muted">No top-level function declarations parsed.</span>{{end}}</div></div><div class="panel"><h2>References</h2><ul class="links">{{range .Record.WikiSearches}}<li><a href="{{.URL}}">{{.Name}}</a></li>{{end}}{{range .Record.OfficialLinks}}<li><a href="{{.URL}}">{{.Name}}</a></li>{{end}}{{if .Record.ProvenanceURL}}<li><a href="{{.Record.ProvenanceURL}}">Header provenance URL</a></li>{{end}}</ul></div></section><section class="warning"><b>Use at your own risk.</b> Historical ASH may change game state, spend resources, depend on retired APIs, or be incompatible with current KoLmafia. Review the source before execution. <a href="../third-party.html">Read the Third-Party Scripts and Disclaimer →</a></section></article>` + foot

const creditsTemplate = head + `<section class="hero compact"><div><p class="eyebrow">CREDIT INDEX</p><h1>People before pile.</h1><p class="lede">Every GitHub owner referenced by the catalog configuration is linked back to their profile. Script-level pages preserve detected authorship and original source URLs.</p></div></section><section class="credit-grid">{{range .Credits}}<a class="credit" href="{{.Profile}}"><b>{{.Name}}</b><span>{{.Role}}</span><small>{{.Profile}}</small></a>{{end}}</section>` + foot
const officialTemplate = head + `<section class="hero compact"><div><p class="eyebrow">REFERENCE DESK</p><h1>Official + community anchors.</h1><p class="lede">These are reference surfaces, not evidence that a cataloged script is current. Script pages link to the relevant wiki search only when title nouns produce a useful lookup.</p></div></section><section class="credit-grid">{{range .Config.OfficialLinks}}<a class="credit" href="{{.URL}}"><b>{{.Name}}</b><span>{{.Kind}}</span><small>{{.URL}}</small></a>{{end}}</section>` + foot
const aboutTemplate = head + `<section class="hero compact"><div><p class="eyebrow">ABOUT / RIGHTS / RISK</p><h1>Archive without ownership theater.</h1></div></section><article class="prose"><h2>Third-Party Scripts and Disclaimer</h2><p>This repository is a community archival and reference collection of KoLmafia <code>.ash</code> scripts gathered from various authors and sources.</p><p>Unless explicitly stated otherwise, the catalog maintainer does not claim authorship, copyright, or ownership of third-party scripts. Copyright remains with the original authors and applicable rights holders. Each script remains subject to its original license, notices, terms, and attribution requirements. Inclusion does not relicense, transfer ownership of, or imply endorsement of any script.</p><p>The automated synchronizer only vendors script bytes when it detects a recognized repository license. Unknown or unrecognized licensing is recorded as metadata-only until redistribution rights can be established.</p><h2>Use at Your Own Risk</h2><p>The scripts and information are provided “as is,” without warranty. Many scripts may be old, experimental, abandoned, incompatible with current KoLmafia versions, or capable of changing game state. Review a script before running it.</p><h2>Catalog contract</h2><ul><li>Original source + commit + hash are first-class fields.</li><li>Per-script HTML5 records accompany vendored artifacts.</li><li>Credit links point back to referenced GitHub owners.</li><li>Static behavior hints are warnings, not execution guarantees.</li><li>Generated pages are deterministic from archive + records.</li></ul></article>` + foot

const groupedIndexTemplate = head + `<section class="hero compact"><div><p class="eyebrow">HYPER-INDEX</p><h1>{{.IndexTitle}}</h1><p class="lede">{{.IndexIntro}}</p></div></section><nav class="jump-index">{{range .Groups}}<a href="#{{slug .Name}}"><b>{{.Name}}</b><span>{{len .Records}}</span></a>{{end}}</nav>{{range .Groups}}<section class="wiki-group" id="{{slug .Name}}"><header><h2>{{.Name}}</h2><span>{{len .Records}} scripts</span></header><div class="wiki-list">{{range .Records}}<a href="{{scriptURL .ID}}"><b>{{.Title}}</b><span>{{.Classification}} · {{if .Author}}{{.Author}}{{else}}author unknown{{end}} · {{.Behavior.Class}}</span><small>{{.Description}}</small></a>{{end}}</div></section>{{end}}` + foot

const thirdPartyTemplate = head + `<section class="hero compact"><div><p class="eyebrow">RIGHTS / ATTRIBUTION / RISK</p><h1>Third-Party Scripts and Disclaimer</h1><p class="lede">The catalog preserves source and attribution without claiming ownership of community scripts.</p></div></section><article class="prose notice-prose"><p>This repository is a community archival and reference collection of KoLmafia <code>.ash</code> scripts gathered from various authors and sources.</p><p>Unless explicitly stated otherwise:</p><ul><li>I do <strong>not</strong> claim authorship, copyright, or ownership of third-party scripts contained in this repository.</li><li>Copyright remains with the original authors and other applicable rights holders.</li><li>Each script remains subject to its <strong>original license, copyright notice, terms, and attribution requirements</strong>, where known.</li><li>Inclusion in this repository does <strong>not</strong> relicense, transfer ownership of, or imply endorsement of any script.</li><li>Source links, author information, and original licensing information should be preserved whenever available.</li><li>Scripts with unclear provenance or licensing should be treated as archival/reference material until redistribution rights can be established.</li></ul><p>This repository itself is simply a catalog/compendium intended to preserve, organize, index, and make historical and current KoLmafia scripting resources easier to discover.</p><h2>Use at Your Own Risk</h2><p>The scripts and information in this repository are provided <strong>“as is,” without warranty of any kind</strong>.</p><p>Many scripts may be old, experimental, abandoned, incompatible with current KoLmafia versions, or capable of changing game state.</p><p>You are responsible for reviewing a script before running it.</p><p>The maintainer of this catalog makes no guarantee that any included script is safe, functional, current, appropriate for your account, or compatible with current KoLmafia or Kingdom of Loathing behavior.</p><h2>Catalog license boundary</h2><p>The repository's MIT license covers original <em>master-ash-catalog</em> software and documentation only. Third-party script snapshots retain their original licenses and notices; their per-script pages show detected license evidence.</p><p><a href="license.html">Read the catalog software license →</a></p></article>` + foot

const licenseTemplate = head + `<section class="hero compact"><div><p class="eyebrow">CATALOG SOFTWARE LICENSE</p><h1>MIT, with a third-party boundary.</h1><p class="lede">This license applies to original master-ash-catalog code and documentation. It does not replace the licenses attached to archived third-party scripts.</p></div></section><article class="prose"><h2>MIT License</h2><p>Copyright (c) 2026 donCannoli-burns</p><p>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:</p><p>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.</p><p>THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p><p><a href="third-party.html">Third-party script rights and disclaimer →</a></p></article>` + foot

const styleCSS = `:root{--bg:#15110f;--panel:#1c1613;--panel2:#211914;--ink:#f3e8d4;--muted:#ab9b87;--line:#65554a;--accent:#d97745;--accent-soft:rgba(217,119,69,.12);--bad:#d95d5d;--read:Georgia,"Times New Roman",serif;--mono:ui-monospace,SFMono-Regular,Menlo,Consolas,"Liberation Mono",monospace}*{box-sizing:border-box}html{background:var(--bg);color:var(--ink)}body{margin:0;min-height:100vh;background:linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.018) 1px,transparent 1px),var(--bg);background-size:100% 48px,48px 100%,auto;font-family:var(--read)}a{color:inherit}.top{position:sticky;top:0;z-index:20;display:flex;justify-content:space-between;gap:20px;align-items:center;padding:11px 20px;border-bottom:1px solid rgba(243,232,212,.17);background:rgba(21,17,15,.94);backdrop-filter:blur(10px)}.brand{display:flex;gap:11px;align-items:center;text-decoration:none}.brand i{width:13px;height:13px;background:var(--accent);box-shadow:7px 7px 0 #664233}.brand b,.brand small{display:block;font-family:var(--mono);text-transform:uppercase;letter-spacing:.12em}.brand b{font-size:11px}.brand small{font-size:8px;color:var(--muted);margin-top:2px}.top nav{display:flex;gap:5px;flex-wrap:wrap}.top nav a{font:9px var(--mono);text-decoration:none;text-transform:uppercase;letter-spacing:.08em;border:1px solid rgba(243,232,212,.16);padding:7px 9px;color:#d0c2ae}.top nav a:hover{border-color:var(--accent);color:#f2b08d}.shell{width:min(1240px,calc(100% - 28px));margin:0 auto;padding:34px 0 72px}.hero{display:grid;grid-template-columns:1.3fr .7fr;gap:28px;padding:34px 0;border-bottom:1px solid rgba(243,232,212,.15);align-items:end}.hero.compact{grid-template-columns:1fr}.eyebrow{font:10px var(--mono);letter-spacing:.17em;color:var(--accent);text-transform:uppercase}.hero h1,.detail h1{font-size:clamp(52px,8vw,104px);line-height:.86;letter-spacing:-.055em;font-weight:400;margin:10px 0 16px}.hero.compact h1{font-size:clamp(46px,7vw,82px)}.lede{font-size:20px;line-height:1.55;color:#d3c4b1;max-width:850px;margin:0}.meter{display:grid;grid-template-columns:auto 1fr;gap:7px 12px;border-left:3px solid var(--accent);padding-left:18px;font-family:var(--mono)}.meter b{font-size:34px;font-weight:400}.meter span{font-size:10px;color:var(--muted);text-transform:uppercase;letter-spacing:.1em;padding-top:9px}.searchbar{display:flex;justify-content:space-between;gap:20px;align-items:end;padding:22px 0}.searchbar label{font:10px var(--mono);letter-spacing:.12em;text-transform:uppercase;color:var(--muted);flex:1}.searchbar input{display:block;width:100%;margin-top:8px;background:#100d0b;border:1px solid var(--line);color:var(--ink);font:16px var(--mono);padding:12px 13px;outline:none}.searchbar input:focus{border-color:var(--accent)}#count{font:10px var(--mono);color:var(--accent);padding-bottom:13px}.cards{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px}.script-card,.panel,.credit,.prose,.ledger,.warning,.empty{background:rgba(28,22,19,.78);border:1px solid rgba(243,232,212,.12)}.script-card{padding:17px;min-height:230px;transition:transform .15s,border-color .15s}.script-card:hover{transform:translateY(-1px);border-color:rgba(217,119,69,.48)}.card-top{display:flex;justify-content:space-between;font:9px var(--mono);color:var(--muted);text-transform:uppercase;letter-spacing:.1em}.script-card h2{font-weight:400;font-size:27px;line-height:1.05;margin:22px 0 7px}.script-card h2 a{text-decoration:none}.muted{color:var(--muted)}.script-card p{font-size:13px;line-height:1.45}.tags{display:flex;gap:5px;flex-wrap:wrap}.tags b,.tags span,.tags i{font:9px var(--mono);padding:5px 6px;border:1px solid rgba(243,232,212,.12);font-style:normal}.tags b{color:#f1ae87;border-color:rgba(217,119,69,.4);background:var(--accent-soft)}.tags span{color:#c5b6a2}.tags i{color:#998b79}.hash{margin-top:18px;font:9px var(--mono);color:#73685c}.empty{padding:30px;grid-column:1/-1}.detail>.eyebrow{margin-top:18px}.detail h1{font-size:clamp(42px,7vw,86px)}.ledger{display:grid;grid-template-columns:repeat(2,1fr);margin:28px 0}.ledger div{padding:14px;border-right:1px solid rgba(243,232,212,.1);border-bottom:1px solid rgba(243,232,212,.1);min-width:0}.ledger small{display:block;font:9px var(--mono);color:var(--accent);letter-spacing:.12em;margin-bottom:7px}.ledger a,.ledger code,.ledger strong{font:11px var(--mono);overflow-wrap:anywhere;font-weight:400}.cols{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin:12px 0}.panel{padding:18px}.panel h2,.prose h2{font-weight:400;font-size:27px;margin:0 0 15px}.panel h3{font:9px var(--mono);letter-spacing:.14em;color:var(--muted);margin:18px 0 8px}.panel ul{line-height:1.6;color:#d2c3af}.function-list{display:flex;flex-wrap:wrap;gap:6px}.function-list code{font:10px var(--mono);padding:6px;border:1px solid rgba(243,232,212,.1);background:#120f0d}.wrap{white-space:normal;line-height:1.6}.links{padding-left:18px}.links a{color:#e7ad8d}.warning{border-left:3px solid var(--bad);padding:16px;margin-top:12px;color:#d7c4b8;line-height:1.55}.warning b{color:#f19b91}.credit-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:24px}.credit{text-decoration:none;padding:16px;min-height:120px}.credit:hover{border-color:var(--accent)}.credit b{display:block;font-size:22px;font-weight:400}.credit span{display:block;font:9px var(--mono);color:var(--accent);margin:8px 0;text-transform:uppercase}.credit small{font:9px var(--mono);color:var(--muted);overflow-wrap:anywhere}.prose{padding:28px;margin-top:24px;max-width:920px}.prose p,.prose li{line-height:1.7;color:#d1c2af}.prose code{font-family:var(--mono)}footer{width:min(1240px,calc(100% - 28px));margin:0 auto;padding:18px 0 32px;border-top:1px solid rgba(243,232,212,.15);display:flex;justify-content:space-between;gap:20px;color:var(--muted);font:9px/1.5 var(--mono);text-transform:uppercase;letter-spacing:.08em}footer a{color:#e7ad8d}footer b{color:#d9b19a;font-weight:500}@media(max-width:900px){.cards,.credit-grid{grid-template-columns:repeat(2,1fr)}.hero,.cols{grid-template-columns:1fr}}@media(max-width:620px){.top{align-items:flex-start;flex-direction:column}.cards,.credit-grid,.ledger{grid-template-columns:1fr}.shell{width:min(100% - 18px,1240px);padding-top:15px}.hero h1{font-size:54px}.searchbar{align-items:stretch;flex-direction:column}.top nav{width:100%}}@media(prefers-reduced-motion:reduce){*{transition:none!important}}.browse-strip{display:grid;grid-template-columns:repeat(5,1fr);border:1px solid rgba(243,232,212,.14);margin:20px 0;background:rgba(28,22,19,.7)}.browse-strip a{text-decoration:none;padding:14px;border-right:1px solid rgba(243,232,212,.1)}.browse-strip a:last-child{border-right:0}.browse-strip b{display:block;font:10px var(--mono);color:var(--accent);letter-spacing:.12em}.browse-strip span{display:block;margin-top:5px;font-size:12px;color:var(--muted)}.card-desc{color:#c9baa7;min-height:58px}.classification-strip{display:grid;grid-template-columns:repeat(3,1fr);border:1px solid rgba(243,232,212,.12);margin:22px 0;background:rgba(28,22,19,.66)}.classification-strip div{padding:13px;border-right:1px solid rgba(243,232,212,.1)}.classification-strip div:last-child{border-right:0}.classification-strip small,.command-panel small{display:block;font:9px var(--mono);color:var(--muted);letter-spacing:.11em;text-transform:uppercase;margin-bottom:6px}.classification-strip strong{font:12px var(--mono);font-weight:400}.command-panel{border:1px solid rgba(217,119,69,.4);background:var(--accent-soft);margin:0 0 20px}.command-panel header{padding:13px 14px;border-bottom:1px solid rgba(217,119,69,.22)}.command-panel header span{display:block;font:10px var(--mono);color:#f2b08d;letter-spacing:.12em;text-transform:uppercase}.command-panel header small{margin-top:6px;line-height:1.5;text-transform:none;letter-spacing:0}.command-panel.unavailable{border-color:rgba(243,232,212,.14);background:rgba(28,22,19,.62)}.command-row{display:grid;grid-template-columns:1fr auto;gap:10px;align-items:center;padding:12px 14px;border-top:1px solid rgba(217,119,69,.17)}.command-row code{font:12px/1.5 var(--mono);overflow-wrap:anywhere}.command-row button{border:1px solid rgba(217,119,69,.55);background:#17110e;color:#f5c0a2;padding:8px 10px;font:9px var(--mono);letter-spacing:.1em;text-transform:uppercase;cursor:pointer}.command-row button:hover,.command-row button:focus-visible{border-color:var(--accent);outline:none;background:rgba(217,119,69,.12)}.jump-index{display:flex;flex-wrap:wrap;border:1px solid rgba(243,232,212,.12);margin:22px 0}.jump-index a{display:flex;gap:8px;text-decoration:none;padding:9px 11px;border-right:1px solid rgba(243,232,212,.1);border-bottom:1px solid rgba(243,232,212,.1);font:10px var(--mono)}.jump-index a:hover{color:#f2b08d}.jump-index span{color:var(--muted)}.wiki-group{scroll-margin-top:75px;margin:30px 0}.wiki-group>header{display:flex;justify-content:space-between;gap:18px;align-items:end;border-bottom:1px solid rgba(243,232,212,.14);padding-bottom:9px}.wiki-group h2{font-size:34px;font-weight:400;margin:0}.wiki-group>header span{font:9px var(--mono);color:var(--muted);text-transform:uppercase}.wiki-list{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));border-left:1px solid rgba(243,232,212,.1)}.wiki-list a{text-decoration:none;padding:13px 14px;border-right:1px solid rgba(243,232,212,.1);border-bottom:1px solid rgba(243,232,212,.1);background:rgba(28,22,19,.5)}.wiki-list a:hover{background:rgba(217,119,69,.06)}.wiki-list b{display:block;font-size:18px;font-weight:400}.wiki-list span,.wiki-list small{display:block;margin-top:5px}.wiki-list span{font:9px var(--mono);color:var(--accent);text-transform:uppercase}.wiki-list small{color:var(--muted);line-height:1.45}.warning a{color:#f2b08d}.notice-prose strong{color:#f3e8d4}@media(max-width:900px){.browse-strip{grid-template-columns:repeat(2,1fr)}.classification-strip{grid-template-columns:1fr}.classification-strip div{border-right:0;border-bottom:1px solid rgba(243,232,212,.1)}.wiki-list{grid-template-columns:1fr}}@media(max-width:620px){.browse-strip{grid-template-columns:1fr}.command-row{grid-template-columns:1fr}.command-row button{justify-self:start}}`
const appJS = `(function(){const q=document.getElementById('q'),cards=[...document.querySelectorAll('.script-card')],count=document.getElementById('count');if(q){const apply=()=>{const s=q.value.trim().toLowerCase();let n=0;for(const c of cards){const ok=!s||c.dataset.search.includes(s);c.hidden=!ok;if(ok)n++}if(count)count.textContent=n+' records'};q.addEventListener('input',apply)}for(const b of document.querySelectorAll('[data-copy]')){b.addEventListener('click',async()=>{const value=b.getAttribute('data-copy')||'';try{await navigator.clipboard.writeText(value);const old=b.textContent;b.textContent='COPIED';setTimeout(()=>b.textContent=old,1000)}catch(e){b.textContent='COPY MANUALLY'}})}})();`

var _ = fmt.Sprintf
