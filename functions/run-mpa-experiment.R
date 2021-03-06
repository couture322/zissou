comp_foo <- function(fish,
                     fleet,
                     year_mpa,
                     mpa_size,
                     sim_years,
                     num_patches,
                     burn_years,
                     enviro = NA,
                     enviro_strength = NA,
                     rec_driver = 'stochastic',
                     simseed = 42) {
  set.seed(simseed)

  no_mpa <-
    sim_fishery(
      fish = fish,
      fleet = fleet,
      manager = create_manager(year_mpa = year_mpa, mpa_size = 0),
      sim_years = sim_years,
      num_patches = num_patches,
      burn_year = burn_years,
      enviro = enviro,
      enviro_strength = enviro_strength,
      rec_driver = rec_driver
    ) %>%
    mutate(experiment = 'no-mpa')

  set.seed(simseed)

  wi_mpa <-
    sim_fishery(
      fish = fish,
      fleet = fleet,
      manager = create_manager(year_mpa = year_mpa, mpa_size = mpa_size),
      sim_years = sim_years,
      num_patches = num_patches,
      burn_year = burn_years,
      enviro = enviro,
      enviro_strength = enviro_strength,
      rec_driver = rec_driver
    ) %>%
    mutate(experiment = 'with-mpa')

  outcomes <- no_mpa %>%
    bind_rows(wi_mpa) %>%
    group_by(year, experiment) %>%
    summarise(
      numbers = sum(numbers),
      biomass = sum(biomass),
      ssb = sum(ssb),
      percent_mpa = mean(mpa),
      catch = sum(biomass_caught),
      profits = sum(profits),
      effort = sum(effort)
    ) %>%
    ungroup()
  raw_outcomes <- no_mpa %>%
    bind_rows(wi_mpa)

  out <- list(outcomes = outcomes,
              raw_outcomes = raw_outcomes)

}