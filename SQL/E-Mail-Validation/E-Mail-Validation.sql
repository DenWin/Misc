CREATE TABLE #EmailValidation (
    EmailAddress  VARCHAR(100)
  , isValid       SMALLINT
);

-- List of valid and invalid mail addresses can be found here:
-- https://en.wikipedia.org/wiki/Email_address

INSERT INTO #EmailValidation
       (isValid, EmailAddress)
VALUES (0,       'invalid.com'),
       (0,       '@invalid.com'),
       (0,       'invalid.com@'),
       (0,       'invalid@.example.com'),
       (0,       'invalid.@example.com'),
       (0,       'invalid³@example.com'),
       (1,       'valid3@example.com'),
       (0,       'invalid@email@example.com'),
       (0,       'invalid@@email.example.com'),
       (0,       'invalid@email+example.com'),
       (0,       '.invalid@example.com'),
       (0,       'invalid..email@example.com'),
       (0,       'invalid.email.g@v'),
       (0,       'invalid@email.c'),
       (0,       'invalid@com.'),
       (1,       'valid@local'),
       (1,       'valid.email@example.com'),
       (1,       'valid.email@example.me'),
       (1,       'valid.email@www.example.com'),
       (1,       'valid.email@some.moresubdomain.example.com'),
       (0,       '---------------'),
       (1,       'simple@example.com'),
       (1,       'very.common@example.com'),
       (1,       'FirstName.LastName@EasierReading.org'),                                    -- (case is always ignored after the @ and usually before)
       (1,       'x@example.com'),                                                           -- (one-letter local-part)
       (1,       'long.email-address-with-hyphens@and.subdomains.example.com'),
       (1,       'user.name+tag+sorting@example.com'),                                       -- (may be routed to user.name@example.com inbox depending on mail server)
       (1,       'name/surname@example.com'),                                                -- (slashes are a printable character, and allowed)
       (1,       'admin@example'),                                                           -- (local domain name with no TLD, although ICANN highly discourages dotless email addresses[29])
       (1,       'example@s.example'),                                                       -- (see the List of Internet top-level domains)
       (0,       '" "@example.org'),                                                         --  (space between the quotes, actually allowed but highly discuraged - hence not accepted as valid!)
       (0,       '"john..doe"@example.org'),                                                 --  (quoted double dot, actually allowed but highly discuraged        - hence not accepted as valid!)
       (1,       'mailhost!username@example.org'),                                           -- (bangified host route used for uucp mailers)
       (1,       'user%example.com@example.org'),                                            -- (% escaped mail route to user@example.com via example.org)
       (1,       'user-@example.org'),                                                       -- (local-part ending with non-alphanumeric character from the list of allowed printable characters)
       (1,       'postmaster@[123.123.123.123]'),                                            -- (IP addresses are allowed instead of domains when in square brackets, but strongly discouraged)
       (1,       'postmaster@[IPv6:2001:0db8:85a3:0000:0000:8a2e:0370:7334]'),               -- (IPv6 uses a different syntax)
       (1,       'contact@[IPv6::1]'),
       (0,       '---------------'),
       (0,       'user@-example.org'),                                                                -- (domain-part starts with a hyphen)
       (0,       'user@example-.org'),                                                                -- (domain-part contains a hyphen)
       (0,       'user@example.-org'),                                                                -- (domain-part contains a hyphen)
       (0,       'user@exam[pl]e.org'),                                                               -- (domain-part contains square brackets but is neither an IPv4 or v6-address)
       (0,       'user@[example.org]'),                                                               -- (domain-part contains square brackets but is neither an IPv4 or v6-address)
       (0,       'abc.example.com'),                                                                  -- (no @ character)
       (0,       'a@b@c@example.com'),                                                                -- (only one @ is allowed outside quotation marks)
       (0,       'a"b(c)d,e:f;g<h>i[j\k]l@example.com'),                                              -- (none of the special characters in this local-part are allowed outside quotation marks)
       (0,       'just"not"right@example.com'),                                                       -- (quoted strings must be dot separated or be the only element making up the local-part)
       (0,       'this is"not\allowed@example.com'),                                                  -- (spaces, quotes, and backslashes may only exist when within quoted strings and preceded by a backslash)
       (0,       'this\ still\"not\\allowed@example.com'),                                            -- (even if escaped (preceded by a backslash), spaces, quotes, and backslashes must still be contained by quotes)
       (0,       '1234567890123456789012345678901234567890123456789012345678901234+x@example.com'),   -- (local-part is longer than 64 characters)
       (0,       'i.like.underscores@but_they_are_not_allowed_in_this_part')                          -- (underscore is not allowed in domain part)

SELECT
    [EmailAddress]
  , [isValid]
  , [Valid] = CASE
                WHEN    [Basic Structure]                 = 'x'
                    AND [Only valid characters in local]  = 'x'
                    AND [Only valid characters in domain] = 'x'
                    AND [No leading dot in local]         = 'x'
                    AND [No consecutive dots]             = 'x'
                    AND [TLD at least 2 char]             = 'x'
                    AND [Max Length - Local]              = 'x'
                    AND [Min Length]                      = 'x'
                THEN 'x'
                ELSE ''
              END
  , *
FROM (
  SELECT
      [EmailAddress]
    , [isValid]
    , [Local]
    , [Domain]
    , [Basic Structure]                 = CASE WHEN [EmailAddress] LIKE '%[^.]@[^.]%' THEN 'x' ELSE '' END
    , [No leading dot in local]         = CASE WHEN [Local] LIKE '[^.]%'              THEN 'x' ELSE '' END
    , [No consecutive dots]             = CASE WHEN [EmailAddress] NOT LIKE '%..%'    THEN 'x' ELSE '' END
    , [TLD at least 2 char]             = CASE WHEN LEN([TLD]) >= 2                   THEN 'x' ELSE '' END
    , [Max Length - Local]              = CASE WHEN LEN([Local]) <= 64                THEN 'x' ELSE '' END
    , [Max Length]                      = CASE WHEN LEN([EmailAddress]) <= 254        THEN 'x' ELSE '' END
    , [Min Length]                      = CASE WHEN LEN([EmailAddress]) >= 5          THEN 'x' ELSE '' END
    , [Only valid characters in local]  = CASE WHEN [Local] NOT LIKE '%[^a-zA-Z0-9.!#$%&''*+-/=?^_`{|}~]%' COLLATE Latin1_General_BIN THEN 'x' ELSE ''  END -- Only valid characters used in Local-Part
    , [Only valid characters in domain] = CASE
                                            WHEN    [Domain] NOT LIKE '%[^a-zA-Z0-9.:-\[\]]%'  COLLATE Latin1_General_BIN {escape '\'} -- if any other char => False
                                                AND [Domain] NOT LIKE '-%'                                                             -- leading dash  => False
                                                AND [Domain] NOT LIKE '%.-%'                                                           -- dot followed by dash => False
                                                AND [Domain] NOT LIKE '%-.%'                                                           -- dash followed by dot => False
                                                AND [Domain] NOT LIKE '%-'                                                             -- ending dash => False
                                                AND (
                                                  (
                                                        0 = CHARINDEX( '[',          [Domain]   )
                                                    AND 0 = CHARINDEX( ']', REVERSE( [Domain] ) )
                                                  )
                                                  OR (
                                                        1 = CHARINDEX( '[',          [Domain]  )
                                                    AND 1 = CHARINDEX( ']', REVERSE( [Domain] ) )
                                                    AND (
                                                      -- Check for IPv4 - a more accurate testing would require way to many checks
                                                      SUBSTRING( [Domain], 2, LEN( [Domain] ) - 2 ) NOT LIKE '%[^0-9.]%'
                                                      -- Check for IPv6 - a more accurate testing would require way to many checks
                                                      OR SUBSTRING( [Domain], 0, 7 ) = '[IPv6:'
                                                    )
                                                  )
                                                )
                                            THEN 'x'
                                            ELSE ''
                                          END
  FROM (
    SELECT
        [EmailAddress]
      , [isValid]
      , [Local]  = LEFT( EmailAddress, LEN( EmailAddress ) -      CHARINDEX( '@', REVERSE( EmailAddress )))
      , [Domain] = REVERSE( SUBSTRING(REVERSE( EmailAddress ), 0, CHARINDEX( '@', REVERSE( EmailAddress ))))
      , [TLD]    = REVERSE(( SELECT CASE
                                      WHEN CHARINDEX( '.', ReverseDomain ) <= 0
                                      THEN ReverseDomain
                                      ELSE SUBSTRING( ReverseDomain, 0, CHARINDEX( '.', ReverseDomain ))
                                    END
                             FROM ( SELECT ReverseDomain = SUBSTRING( REVERSE( EmailAddress )
                                                                    , 0
                                                                    , CHARINDEX( '@', REVERSE( EmailAddress )))
                             ) x
                   ))
    FROM #EmailValidation
  ) x
) x

DROP TABLE #EmailValidation;
