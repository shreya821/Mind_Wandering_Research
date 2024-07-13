population <- c("ctrl", "clinical", "all", "schz", "bipolar", "adhd")

for (pop in population){
    cat("For", pop, ":\n")
    
    go_trials_file <- paste('go_trials', '_', pop, '.txt', sep = "")
    stop_trials_file <- paste('stop_trials', '_', pop, '.txt', sep = "")
    successful_go_trials_file <- paste('successful_go_trials', '_', pop, '.txt', sep = "")
    successful_stop_trials_file <- paste('successful_stop_trials', '_', pop, '.txt', sep = "")
    
    go_trials <- scan(go_trials_file, quiet = TRUE)
    stop_trials <- scan(stop_trials_file, quiet = TRUE)
    successful_go_trials <- scan(successful_go_trials_file, quiet = TRUE)
    successful_stop_trials <- scan(successful_stop_trials_file, quiet = TRUE)

    size_go = go_trials[1]
    mean_percent_successful_go = mean(successful_go_trials) * (100 / size_go)
    sem_percent_successful_go = sd(successful_go_trials) * (100 / size_go) / sqrt(size_go)

    
    cat(sprintf('The percentage of successful go trials were % 0.2f percent.\n', mean_percent_successful_go))
    cat(sprintf('The SEM of percentage of successful go trials were % 0.2f percent.\n', sem_percent_successful_go))

    size_stop = stop_trials[1]
    mean_percent_successful_stop = mean(successful_stop_trials) * (100 / size_stop)
    sem_percent_successful_stop = sd(successful_stop_trials) * (100 / size_stop) / sqrt(size_stop)

    cat(sprintf('The percentage of successful stop trials were % 0.2f percent.\n', mean_percent_successful_stop))
    cat(sprintf('The SEM of percentage of successful stop trials were % 0.2f percent.\n', sem_percent_successful_stop))
    

    cat('\n')
    
}



