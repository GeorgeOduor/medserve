#
#
#
golem::fill_desc(
  pkg_name = "medserver",
  pkg_title = "Medical Energency Services",
  pkg_description = "This is an n  R shiny web app that can be used to visualize how demand for emergency medical services is changing over different time periods like, on a monthly, daily, and weekly basis.",
  author_first_name = "George",
  author_last_name = "Oduor",
  author_email = "george.wamaya@gmail.com",
  repo_url = NULL
)
golem::set_golem_options(talkative = T,golem_version = 1.0,app_prod = F)
usethis::use_mit_license("George")
usethis::use_readme_rmd(open = FALSE)
usethis::use_code_of_conduct(contact = "MIT")
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md(open = FALSE)
usethis::use_git()
golem::use_recommended_tests()
golem::use_favicon()
golem::remove_favicon()
golem::use_utils_ui(with_test = F)
golem::use_utils_server(with_test = F)
rstudioapi::navigateToFile("dev/02_dev.R")
