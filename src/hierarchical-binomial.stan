data {
  int<lower=0> J; // number of items
  int<lower=0> y[J]; // number of successes for j
  int<lower=0> n[J]; // number of trials for j
}
parameters {
  real<lower=0, upper=1> theta[J]; // chance of success for j
  real<lower=0, upper=1> lambda;   // prior mean chance of success
  real<lower=0.1> kappa;           // prior count
}
transformed parameters {
  real<lower=0> alpha = lambda * kappa; // prior success count
  real<lower=0> beta = (1 - lambda) * kappa; // prior failure count
}
model {
  lambda ~ uniform(0, 1); // hyperprior
  kappa ~ pareto(0.1, 1.5); // hyperprior
  theta ~ beta(alpha, beta); // prior
  y ~ binomial(n, theta); // likelihood
}
generated quantities {
  real<lower=0,upper=1> avg = mean(theta); // avg success
  int<lower=0, upper=1> above_avg[J]; // true if j is above avg
  int<lower=1, upper=J> rnk[J]; // rank of j
  int<lower=0, upper=1> highest[J]; // true if j is highest rank
  for (j in 1:J) {
    above_avg[j] = (theta[j] > avg);
    rnk[j] = rank(theta, j) + 1;
    highest[j] = (rnk[j] == 1);
  }
}
