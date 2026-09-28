package catalog

import "testing"

func TestParseGitHubURL(t *testing.T) {
	cases := []struct{ u, o, r, p string }{{"https://github.com/C2Talon/c2t_lib", "C2Talon", "c2t_lib", ""}, {"https://github.com/twistedmage/assorted-kol-scripts/blob/master/scripts/zlib.ash#L4", "twistedmage", "assorted-kol-scripts", "scripts/zlib.ash"}, {"https://github.com/Prusias-kol/pTrack/tree/main/kolmafia/scripts", "Prusias-kol", "pTrack", "kolmafia/scripts"}}
	for _, c := range cases {
		g, e := ParseGitHubURL(c.u)
		if e != nil || g.Owner != c.o || g.Repo != c.r || g.Path != c.p {
			t.Fatalf("%s => %#v %v", c.u, g, e)
		}
	}
}
