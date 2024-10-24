const passport = require("passport");
const DiscordStrategy = require("passport-discord").Strategy;

passport.use(
  new DiscordStrategy(
    {
      clientID: "1298942322482090005",
      clientSecret: "qU1jYGISnsdncItBXQEih5V8xSoUvASb",
      callbackURL: "http://localhost:3000/auth/discord/callback",
      scope: ["identify"],
    },
    function (accessToken, refreshToken, profile, done) {
      // Aquí puedes manejar el perfil y el acceso
      return done(null, profile);
    }
  )
);

// Ruta de autenticación de Discord
app.get("/auth/discord", passport.authenticate("discord"));

// Ruta de callback
app.get(
  "/auth/discord/callback",
  passport.authenticate("discord", { failureRedirect: "/" }),
  function (req, res) {
    // Si la autenticación es exitosa, redirige a donde desees
    res.redirect("/");
  }
);
