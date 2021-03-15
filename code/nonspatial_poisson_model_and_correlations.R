
###############################################################
# estimate and plot non-spatial poisson models + correlations #
###############################################################

# dependencies
library(here)
source(here("code/dependencies.R"))

# load covid data and covariates
source(here("code/load_and_merge_data.R"))

# non-spatial poisson model ---------------------------------------------------------------------------------------

source(here("code/regression_formulas.R"))

poisson_model_p1 <- glm(regression_formula_p1, family = poisson(), data = df)
poisson_model_p2 <- glm(regression_formula_p2, family = poisson(), data = df)
poisson_model_p3 <- glm(regression_formula_p3, family = poisson(), data = df)

vi(poisson_model_p1) %>% 
  mutate(Variable = fct_reorder(Variable, Importance)) %>% 
  ggplot(aes(x = Importance, y = Variable, fill = Sign)) + 
  geom_col() + 
  ggtitle("Variable Importance in Period 1, Non-Spatial Poisson Model")

ggsave(here("figures/poisson_model_p1.png"))

vi(poisson_model_p2) %>% 
  mutate(Variable = fct_reorder(Variable, Importance)) %>% 
  ggplot(aes(x = Importance, y = Variable, fill = Sign)) + 
  geom_col() + 
  ggtitle("Variable Importance in Period 2, Non-Spatial Poisson Model")

ggsave(here("figures/poisson_model_p2.png"))
      
vi(poisson_model_p3) %>% 
  mutate(Variable = fct_reorder(Variable, Importance)) %>% 
  ggplot(aes(x = Importance, y = Variable, fill = Sign)) + 
  geom_col() + 
  ggtitle("Variable Importance in Period 3, Non-Spatial Poisson Model")

ggsave(here("figures/poisson_model_p3.png"))


# plot covariance -------------------------------------------------------------------------------------------------

M <- cor(df %>% select_if(is.numeric), use='pairwise.complete') # select_at(all.vars(regression_formula_p3)))

res1 <- cor.mtest(
  df %>% select_if(is.numeric), 
  use='pairwise.complete',
  conf.level = .95)

png(here('figures/corrplot.png'), width=10, height=10, units='in', res=300)

corrplot(M, method = 'color', order = 'hclust', addrect = 7,
         p.mat = res1$p, insig = "label_sig",
         sig.level = c(.001, .01, .05), pch.cex = .5, pch.col = "white",
         tl.col = 'black', tl.cex = .9
         )

dev.off()

df %>% select_if(is.numeric) %>% correlate(method='spearman') %>% network_plot(min_cor = .2)

library(igraph)
library(ggraph)

# Create a tidy data frame of correlations
tidy_cors <- df %>% select_if(is.numeric) %>% 
  correlate(method='spearman') %>% 
  stretch()

# Convert correlations stronger than some value
# to an undirected graph object
graph_cors <- tidy_cors %>% 
  filter(abs(r) > 0.5) %>% 
  graph_from_data_frame(directed = FALSE)

# Plot
ggraph(graph_cors, layout='kk') +
  geom_edge_link(aes(edge_alpha = abs(r), edge_width = abs(r), color = r)) +
  guides(edge_alpha = "none", edge_width = "none") +
  scale_edge_colour_gradientn(limits = c(-1, 1), colors = c("firebrick2", "dodgerblue2")) +
  scale_edge_width_continuous(limits = c(0, 1)) + 
  geom_node_point(color = "black", fill = 'white', size = 5, shape=21) +
  geom_node_label(aes(label = name), repel = TRUE, alpha=0.85) +
  theme_graph()

ggsave(here("figures/correlations_gt_pt5.png"), width=10, height=10)

# spatial modeling ------------------------------------------------------------------------------------------------
# 
# we didn't end up using the carbayes approach because we couldn't get the 
# markov chains to converge.
#
# 
# source(here("code/prepare_data_for_carbayes.R"))
# 
# # model for period 1
# 
# bottom_row <- function(df) { df[nrow(df),] }
# second_half <- function(df) { df[floor(nrow(df)/2):nrow(df),] }
# 
# model1_coefs <- poisson_model_p1$coefficients
# model1_var <- diag(vcov(poisson_model_p1)) 
# 
# model1_chain1 <- CARBayes::S.CARleroux(
#   regression_formula_p1,
#   data = df_spatial %>% st_drop_geometry(),
#   family='poisson', 
#   prior.mean.beta = model1_chain1$samples$beta %>% bottom_row(), 
#     # model1_coefs, # + 
#     # rnorm(n = length(model1_coefs), mean = 0, 
#     #       sd = abs(model1_coefs)/10), # sqrt(model1_var) * 1000),
#   # prior.var.beta = # apply(model1_chain1$samples$beta %>% second_half(), 2, function(x) max(x) - min(x))^3,
#     # model1_var * 10000000,
#     # abs(model1_coefs) * 100000,
#   # formula.omega = short_regression_formula_p1_rhs,
#   W = W, burnin = 1e3, n.sample = 3e4, thin=200)
# 
# plot(model1_chain1$samples$beta)
# 
# saveRDS(model1_chain1, 'model1_chain1.rds')
# 
# # model for period 2
# 
# model2_chain1 <- CARBayes::S.CARbym(
#   regression_formula_p2,
#   data = df_spatial %>% st_drop_geometry(),
#   family='zip', 
#   prior.mean.beta = 
#     poisson_model_p1$coefficients,
#   formula.omega = short_regression_formula_p1_rhs,
#   W = W, burnin = 1e5, n.sample = 3e5, thin=100)
# 
# saveRDS(chain2, 'model2_chain1.rds')
# 
# # model for period 3
# 
# model2_chain1 <- CARBayes::S.CARbym(
#   regression_formula_p2,
#   data = df_spatial %>% st_drop_geometry(),
#   family='zip', 
#   prior.mean.beta = 
#     poisson_model_p1$coefficients,
#   formula.omega = short_regression_formula_p1_rhs,
#   W = W, burnin = 1e5, n.sample = 3e5, thin=100)
# 
# saveRDS(chain2, 'model2_chain1.rds')

