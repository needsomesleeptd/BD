WITH combinations AS (SELECT *
                      FROM generate_series(1, 8) AS a
                               CROSS JOIN generate_series(1, 8) AS b
                               CROSS JOIN generate_series(1, 8) AS c
                               CROSS JOIN generate_series(1, 8) AS d
                               CROSS JOIN generate_series(1, 8) AS e
                               CROSS JOIN generate_series(1, 8) AS f
                               CROSS JOIN generate_series(1, 8) AS g
                               CROSS JOIN generate_series(1, 8) AS h)

SELECT *
from combinations
where (
          -- horizontal
              not a in (b, c, d, e, f, g, h)
              and not b in (c, d, e, f, g, h)
              and not c in (d, e, f, g, h)
              and not d in (e, f, g, h)
              and not e in (f, g, h)
              and not f in (g, h)
              and not g in (h)
              -- positive diag
              and not a in (b + 1, c + 2, d + 3, e + 4, f + 5, g + 6, h + 7)
              and not b in (c + 1, d + 2, e + 3, f + 4, g + 5, h + 6)
              and not c in (d + 1, e + 2, f + 3, g + 4, h + 5)
              and not d in (e + 1, f + 2, g + 3, h + 4)
              and not e in (f + 1, g + 2, h + 3)
              and not f in (g + 1, h + 2)
              and not g in (h + 1)
              --negative diag
              and not a in (b - 1, c - 2, d - 3, e - 4, f - 5, g - 6, h - 7)
              and not b in (c - 1, d - 2, e - 3, f - 4, g - 5, h - 6)
              and not c in (d - 1, e - 2, f - 3, g - 4, h - 5)
              and not d in (e - 1, f - 2, g - 3, h - 4)
              and not e in (f - 1, g - 2, h - 3)
              and not f in (g - 1, h - 2)
              and not g in (h - 1)
          );