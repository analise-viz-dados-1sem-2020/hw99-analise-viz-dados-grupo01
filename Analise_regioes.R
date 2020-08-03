library(tidyverse), library(summarytools)

df <- read.csv2("data-raw/csv_sistemas.csv")

#DATA FRAME E GRÁFICO DE CASOS POR REGIÃO

df_reg <- df %>% 
  group_by(MACRO) %>% 
  summarise(EVOLUCAO=n()) %>% 
  rename("CASOS"="EVOLUCAO")

df_reg %>% 
  ggplot()+
  geom_col(aes(x=CASOS,y=MACRO), fill="#87CEFA")+
  labs(title="Número de casos por Região",x="Número de casos",y="Macrorregião")

ggsave("img/casos_regiao.png")

#DATA FRAME E GRÁFICO DE ÓBITOS POR REGIÃO

df_obitos <- df %>% 
  group_by(MACRO) %>% 
  filter(EVOLUCAO=="OBITO") %>% 
  summarise(EVOLUCAO=n()) %>% 
  rename("OBITOS"="EVOLUCAO")

df_obitos %>% 
  ggplot()+
  geom_col(aes(x=OBITOS,y=MACRO),fill="#9932CC")+
  labs(title="Número de óbitos por região", x="Número de óbitos", y="Macrorregião")

ggsave("img/obitos_regiao.png")


#DATA FRAME E GRÁFICO DE LETALIDADE POR REGIÃO

df_letal <- left_join(df_reg,df_obitos,by="MACRO") %>% 
  mutate(df_letal,TAXA_LETALIDADE=OBITOS/CASOS*100)

df_letal %>% 
  ggplot()+
  geom_col(aes(y= reorder(MACRO,+TAXA_LETALIDADE),x=TAXA_LETALIDADE),fill="#FF0000")+
  labs(title= "Taxa de Letalidade por região", y="Macrorregião", x="Taxa de Letalidade (%)")
  
ggsave("img/letalidade_regiao.png")

#DATA FRAME DE CASOS POR FAIXA ETÁRIA EM CADA REGIÃO

df_idade <- df %>% 
  group_by(MACRO,FAIXA_ETARIA) %>% 
  summarise(CASOS=n())

Idade <- df_idade %>% 
  pivot_wider(names_from = MACRO, values_from = CASOS) %>% 
  rename("LESTE_DO_SUL"="LESTE DO SUL")

#GRÁFICOS DE REGIÕES COM MAIOR LETALIDADE

Idade %>% 
  ggplot()+
  geom_col(aes(x=NORDESTE,y=FAIXA_ETARIA),fill="#FF4500")+
  labs(title="Número de casos por faixa etária", subtitle="Região Nordeste", x="Número de casos", y="Faixa etária")
ggsave("img/nordeste.png")

Idade %>% 
  ggplot()+
  geom_col(aes(x=NORTE,y=FAIXA_ETARIA),fill="#FF8C00")+
  labs(title="Número de casos por faixa etária", subtitle="Região Norte", x="Número de casos", y="Faixa etária")
ggsave("img/norte.png")

Idade %>% 
  ggplot()+
  geom_col(aes(x=SUDESTE,y=FAIXA_ETARIA),fill="#FFA500")+
  labs(title="Número de casos por faixa etária", subtitle="Região Sudeste", x="Número de casos", y="Faixa etária")
ggsave("img/sudeste.png")

#GRÁFICOS DE REGIÕES COM MENOR LETALIDADE

Idade %>% 
  ggplot()+
  geom_col(aes(x=OESTE,y=FAIXA_ETARIA),fill="#008000")+
  labs(title="Número de casos por faixa etária", subtitle="Região Oeste", x="Número de casos", y="Faixa etária")
ggsave("img/oeste.png")

Idade %>% 
  ggplot()+
  geom_col(aes(x=LESTE_DO_SUL,y=FAIXA_ETARIA),fill="#228B22")+
  labs(title="Número de casos por faixa etária", subtitle="Região Leste do Sul", x="Número de casos", y="Faixa etária")
ggsave("img/leste_do_sul.png")

Idade %>% 
  ggplot()+
  geom_col(aes(x=NOROESTE,y=FAIXA_ETARIA),fill="#32CD32")+
  labs(title="Número de casos por faixa etária", subtitle="Região Noroeste", x="Número de casos", y="Faixa etária")
ggsave("img/noroeste.png")




