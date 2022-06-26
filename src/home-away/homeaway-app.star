load("render.star", "render")
load("http.star", "http")
load("cache.star", "cache")
load("encoding/base64.star", "base64")

LOCATION_STATUS_URL = "ENVIRON_REPLACE_HOMEAWAY_WEBHOOK"

HOME_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI
WXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gYaDiAviOYklQAAAJxJREFUOMvNksluwkAQRF8Nhvz/
T3LNJZIxXl4OmUgjyxgihEiderqqetPAK6EO6rCn6XbMX8Bnja9JTn/pPKu9WtSoZ3V81Dyqk1qa
XPzBeM/c1+5lg0vlpjZfGnICAnRJlnWBJNabze2EUY/ApRYrVbg3ZYAFEPiIKjADhyRphK4mWHPT
7wabhva9x5VnP9v7C3S3dtu4vvxLfAMEC5NBiYtcpwAAAABJRU5ErkJggg==
""")

WORK_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI
WXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gYaDjAdCvNnRAAAAG1JREFUOMvNkkEOgCAMBLeG+ADe
bDzoQ/2CcBmPggcBiQl7a5p0J5NKfwRYgcCdACwtBwLgk9kDZ0tjKTnRs7GCMCcC+OAJSZp6hU+l
lhKde1uamZUIXI+HsSTG1j+QFFIHu6QDmCtvREmbhsgFPEyTyUXsl4kAAAAASUVORK5CYII=
""")

AWAY_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI
WXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gYaDjg1959FtgAAAJhJREFUOMvNkkEOwjAMBNcOEp/g
//+jPVBVJMPFqUqggdxqKbJie9cbx9JpDLiGz8AEFGCJmMXZrOIuFSTJI54iZ5JsXyzJw5e2O4Nq
3xV0Cl1Srnczs7bGewRmViTdA5i+KfU/FN/Cp4+3j8wAmA/rfxHUfMxknKCn2EcBh0Pcyds2sf2+
2M5V0tp2yMDSdgIewDMIs05pL4yCnkWSylndAAAAAElFTkSuQmCC
""")

ERROR_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI
WXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gYaDwAV2qyzsgAAAIJJREFUOMvNksEOgyAQRGeIPTSN
8eb//5837+3zoCaKokuTJp0LAXaG5YH0KwEGuKtLF3sfSX0kJD/5mZuY1dSEcDUPmYEEvO9CUm62
7bNC26dQ05b6Mj4KnTW14HZXyIC+IuCKAQotRl+pZC51cPABw5dfHUlayY+S2gr/aLvTX2gCStiJ
uO+1/VkAAAAASUVORK5CYII=
""")

def main():

    matt_cache = cache.get("matt_location")
    anthony_cache = cache.get("anthony_location")

    if matt_cache != None and anthony_cache != None:
        anthony = anthony_cache
        matt = matt_cache

    else:
        resp = http.get(LOCATION_STATUS_URL, auth=('ENVIRON_REPLACE_N8N_USER', 'ENVIRON_REPLACE_N8N_PASS'))

        if resp.status_code != 200:
            return render.Root(
            child = render.Row(
                children = [
                    render.Column(children = [
                        render.Padding(child=render.Text("Matt"), pad=(0,0,0,4)),
                        render.Image(src=ERROR_ICON)
                    ], cross_align = "center"),
                    render.Box(width=1, height=32, color="#808080"),
                    render.Column(children = [
                        render.Padding(child=render.Text("Anth"), pad=(0,0,0,4)),
                        render.Image(src=ERROR_ICON)
                    ], cross_align = "center"),
                ],
                main_align = "space_evenly",
                cross_align = "center",
                expanded = True
            )
        )

        matt = resp.json()['MattLocation']
        anthony = resp.json()['AnthonyLocation']

        cache.set("matt_location", matt, ttl_seconds = 300)
        cache.set("anthony_location", anthony, ttl_seconds = 300)

        matt_icon = ""
        anthony_icon = ""

    if matt == 'home':
        matt_icon = HOME_ICON
    elif matt == "work":
        matt_icon = WORK_ICON
    elif matt == "away":
        matt_icon == AWAY_ICON
    else:
        matt_icon == ERROR_ICON


    if anthony == 'home':
        anthony_icon = HOME_ICON
    elif anthony == "work":
        anthony_icon = WORK_ICON
    elif anthony == "away":
        anthony_icon == AWAY_ICON
    else:
        anthony_icon == ERROR_ICON

    return render.Root(
        child = render.Row(
            children = [
                render.Column(children = [
                    render.Padding(child=render.Text("Matt"), pad=(0,0,0,4)),
                    render.Image(src=matt_icon)
                ], cross_align = "center"),
                render.Box(width=1, height=32, color="#808080"),
                render.Column(children = [
                    render.Padding(child=render.Text("Anth"), pad=(0,0,0,4)),
                    render.Image(src=anthony_icon)
                ], cross_align = "center"),
            ],
            main_align = "space_evenly",
            cross_align = "center",
            expanded = True
        )
    )