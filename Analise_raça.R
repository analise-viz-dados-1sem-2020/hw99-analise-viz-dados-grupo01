library(tidyverse); library(summarytools);

df <- read.csv2("data-raw/csv_sistemas.csv")

dfSummary(df)

#DATA FRAME E GRÁFICO DE CASOS POR RAÇA 

df_casos_raca <- df %>% 
  group_by(RACA) %>% 
  summarise(CASOS = n())

df_casos_raca %>% 
  mutate(RACA = fct_reorder(RACA, CASOS, .desc = TRUE)) %>% 
  ggplot(aes(x = RACA, y = CASOS))+
  geom_bar(stat = 'identity', fill = "#66CDAA")+
  labs(title = "Número de casos confirmados por Raça", x = "Raça", y = "Número de casos confirmados")  

ggsave("img/casos_raça.png")

## GRÁFICO DE CASOS POR RAÇAS - RETIRANDO AS NÃO INFORMADAS

casos_raca_inf <- df_casos_raca %>% 
  arrange(CASOS) %>% 
  head(5)

casos_raca_inf %>% 
  mutate(RACA = fct_reorder(RACA, CASOS, .desc = TRUE)) %>% 
  ggplot(aes(x = RACA, y = CASOS))+
  geom_bar(stat = 'identity', fill = "#66CDAA")+
  labs(title = "Número de casos confirmados por Raça", x = "Raça", y = "Número de casos confirmados")

ggsave("img/casos_raça_informados.png")


#DATA FRAME E GRÁFICO DE ÓBITOS POR RAÇA

df_obitos_raca <- df %>% 
  group_by(RACA) %>% 
  filter (EVOLUCAO == "OBITO") %>% 
  summarise(OBITOS = n())

df_obitos_raca %>%
  mutate(RACA = fct_reorder(RACA, OBITOS, .desc = TRUE)) %>% 
  ggplot(aes(x = RACA, y = OBITOS))+
  geom_bar(stat = 'identity', fill = "#D2691E")+
  labs(title = "Número de óbitos por Raça", x = "Raça", y = "Número de óbitos")

ggsave("img/obitos_raça.png")

## GRÁFICO DE OBITOS POR RAÇAS - RETIRANDO AS NÃO INFORMADAS

obitos_raca_inf <- df_obitos_raca [-4,]

obitos_raca_inf %>% 
  mutate(RACA = fct_reorder(RACA, OBITOS, .desc = TRUE)) %>% 
  ggplot(aes(x = RACA, y = OBITOS))+
  geom_bar(stat = 'identity', fill = "#D2691E")+
  labs(title = "Número de óbitos por Raça", x = "Raça", y = "Número de óbitos")

ggsave("img/obitos_raça_informados.png")


#DATA FRAME E GRÁFICO DE LETALIDADE POR RAÇA

df_letal_raca <- left_join(df_casos_raca, df_obitos_raca, by = "RACA")

letal_raca <- df_letal_raca [-4,]

df_letal_raca <- letal_raca %>% 
  mutate(TAXA_LETALIDADE = OBITOS/CASOS*100)

df_letal_raca %>% 
  mutate(RACA = fct_reorder(RACA, TAXA_LETALIDADE, .desc = TRUE)) %>% 
  ggplot(aes(x = RACA, y = TAXA_LETALIDADE))+
  geom_bar(stat = 'identity', fill = "#B22222")+
  labs(title = "Taxa de Letalidade por Raça", x = "Raça", y = "Taxa de letalidade (%)")

ggsave("img/letalidade_raca.png")
