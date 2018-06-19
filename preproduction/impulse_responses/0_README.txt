
IR measurements sonic epistemologies

2016-01-10/11 hek basel
2016-01-2x postpro rm
2016-01-31 readme

5 mic positions (a–e)
14 loudspeakers/positions (1–14, 12 reused)
3 microphone pairs (kk, dpa, ortf)

detailed information in .../ir/dok/memo.txt

jconvolver usage
----------------

$ cd .../ir/irdb
$ jconvolver -M -V <config-file>

– -M -V : optimisation flags
– -N <name> can be used to assign jack name (useful if multiple convolvers used)

configuration files
-------------------

– related to irdb_44 subdirectory
– if jconvolver is called from a different path,
  the /cd ./irdb_44 can be adjusted

–> all speaker positions, all listening positions, dummy head mic
   (14x10 matrix, outputs are listening positions a–e in pairs)

se_kk_x_000_t1.conf : door to staircase open (for position a only)
se_kk_x_000_t2.conf : door to staircase closed (for position a only)
se_kk_x_000_t5.conf : door to staircase (for position a only),
                      speakers 13 and 14 play with subwoofers added

–> all speaker positions for single listening position, dummy head mic
   (14x2 matrix)

e.g. se_kk_a_000_t1.conf

–> for position d: all speaker positions, all 4 listening angles, dummy head

e.g. se_kk_d_xxx_t1.conf

–> all configurations also for dpa mic (_dpa_) and ortf mics (_ortf_)

