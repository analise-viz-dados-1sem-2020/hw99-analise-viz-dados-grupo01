library(dplyr)
library(tidyverse)
library(summarytools)
library(ggplot2)
dados <- read.csv2("data-raw/csv_sistemas.csv")

# DATA FRAME E GRÁFICO DE CASOS POR SEXO
df_casos <- dados %>%
  group_by(SEXO)%>%
  summarise(CLASSIFICACAO_CASO=n())%>%
  rename("CASOS"="CLASSIFICACAO_CASO")

# EXCLUIR SEXO NÃO INFORMADO
df_caso <- df_casos [-3,]

df_caso %>%
  ggplot()+
  geom_col(aes(x=CASOS, y= SEXO), fill="#C71585")+
  labs(title="Número de casos por gênero",x="Número de casos",y="Gênero")+
  ggsave("img/casos_gênero.png")

#DATA FRAME E GRÁFICO DE ÓBITOS POR SEXO

df_obitos <- dados %>% 
  group_by(SEXO) %>% 
  filter(EVOLUCAO=="OBITO") %>% 
  summarise(EVOLUCAO=n()) %>% 
  rename("OBITOS"="EVOLUCAO")

df_obitos %>% 
  ggplot()+
  geom_col(aes(x=OBITOS,y=SEXO),fill="#DAA520")+
  labs(title="Número de óbitos por gênero", x="Número de óbitos", y="Gênero")
ggsave("img/obitos_gênero.png")

#EXPLORANDO O NÚMERO DE ÓBITO POR SEXO ENTRE AS FAIXAS ETÁRIAS
df_obitos2 <- dados %>% 
  group_by(SEXO, FAIXA_ETARIA) %>% 
  filter(EVOLUCAO=="OBITO") %>% 
  summarise(EVOLUCAO=n()) %>% 
  rename("OBITOS"="EVOLUCAO")

df_obitos2 %>% 
  ggplot()+
  geom_col(aes(x=OBITOS,y=FAIXA_ETARIA), fill="#40E0D0", color="#40E0D0")+
  facet_wrap(~SEXO)+
  labs(title="Número de óbitos por gênero entre as faixas etárias", x="Número de óbitos", y="Faixa etária")
ggsave("img/obitos_gêneroefaixa.png") 

#DATA FRAME E GRÁFICO DE LETALIDADE POR SEXO

df_let <- left_join(df_caso,df_obitos,by="SEXO") %>% 
  mutate(TAXA_LETALIDADE=OBITOS/CASOS*100)

df_let %>% 
  ggplot()+
  geom_col(aes(y= reorder(SEXO,+TAXA_LETALIDADE),x=TAXA_LETALIDADE), fill="#8B0000", color= "#8B0000")+
  labs(title= "Taxa de Letalidade por gênero", y="Gênero", x="Taxa de Letalidade (%)")
ggsave("img/letalidade_genero.png")

#EXPLORANDO A TAXA DE LETALIDADE DO SEXO FEMININO ENTRE AS RAÇAS
df_raça <- dados %>% 
  group_by(SEXO, RACA) %>% 
  summarise(CLASSIFICACAO_CASO=n()) %>% 
  rename("CASOS"="CLASSIFICACAO_CASO")

# FILTRAR SEXO FEMININO E RETIRANDO NÃO INFORMADO
df_rc_caso <-df_raça [-4,] %>%
  filter(SEXO=="FEMININO")

df_raçaob <- dados %>% 
  group_by(SEXO, RACA) %>% 
  filter(EVOLUCAO=="OBITO") %>% 
  summarise(EVOLUCAO=n()) %>% 
  rename("OBITOS"="EVOLUCAO")
# FILTRAR SEXO FEMININO E RETIRANDO NÃO INFORMADO
df_rc_obito <-df_raçaob [-4,] %>%
  filter(SEXO=="FEMININO")

df_letalidaderaça <- left_join(df_rc_caso,df_rc_obito,by="RACA") %>% 
  mutate(TAXA_LETALIDADE=OBITOS/CASOS*100)

df_letalidaderaça %>% 
  ggplot()+
  geom_col(aes(x=TAXA_LETALIDADE,y=RACA), fill=c("#9ACD32","#FFD700","#8B0000","#FFA500","#FF4500"))+
  labs(title= "Taxa de Letalidade entre mulheres por recorte de raça", y="Raça", x="Taxa de Letalidade (%)")
ggsave("img/letalidade.mulheres_raça.png")
  
