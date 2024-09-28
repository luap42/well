# Pin npm packages by running ./bin/importmap

pin "application"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
