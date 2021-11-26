# -*- coding: utf-8 -*-
"""
Created on Mon Sep 27 11:43:34 2021

@author: Pedro
"""

from mesa import Agent, Model
from mesa.time import RandomActivation
from mesa.space import MultiGrid
from mesa.datacollection import DataCollector
from scipy.stats import pareto, norm
from random import randint
import matplotlib.pyplot as plt
import numpy as np

def compute_mobility(model, tipo_agente):
    mobilidade_agente = [agent.move_id for agent in model.schedule.agents if agent.get_type() == tipo_agente]
    mobility = sum(mobilidade_agente)/len(mobilidade_agente)
    return(mobility)

def compute_mobility_casa(model):
    return(compute_mobility(model, 'casa'))

def compute_mobility_rua(model):
    return(compute_mobility(model, 'rua'))

def gini_espacial(model, tipo_agente):
    ocup = [len([pessoa for pessoa in cell[0] if pessoa.get_type() == tipo_agente]) for cell in model.grid.coord_iter()]
    x = sorted(ocup)
    N = model.grid.height * model.grid.width
    B = sum( xi * (N-i) for i,xi in enumerate(x) ) / (N*sum(x))
    return (1 + (1/N) - 2*B)

def gini_espacial_casa(model):
    return(gini_espacial(model, 'casa'))

def gini_espacial_rua(model):
    return(gini_espacial(model, 'rua'))

class Locacao:
    '''
    '''
    def __init__(self, width, height, model):
        value_dict = dict()
        self.model = model
        for i in range(width):
            value_dict[i] = dict()
            for j in range(height):
                value_dict[i][j] = 0
        self.value_dict = value_dict
        
    def update_value(self):
        for cell in self.model.grid.coord_iter():
            viz = self.model.grid.get_neighborhood((cell[1], cell[2]),
                                                   moore = True,
                                                   include_center = True)
            pessoas = []
            for cell_v in viz:
                pessoas.extend(self.model.grid.get_cell_list_contents(cell_v))
            
            casas = [pessoa for pessoa in pessoas if pessoa.get_type() == 'casa']
            num_ocup = len(casas)/9
            self.value_dict[cell[1]][cell[2]] = num_ocup
            
    def get_valor(self, x, y):
        return(self.value_dict[x][y])
                
class Pessoa(Agent):
    '''
    '''
    
    def __init__(self, unique_id, model, type_pessoa, thresh):
        super().__init__(unique_id, model)
        self.thresh = thresh
        self.tipo = type_pessoa
        self.move_id = 0
        
    def move(self):
        new_position_x = randint(0, self.model.grid.height-1)
        new_position_y = randint(0, self.model.grid.width-1)
        new_position = (new_position_x, new_position_y)
        self.model.grid.move_agent(self, new_position)
    
    def get_type(self):
        return(self.tipo)
    
    def get_thresh(self):
        return(self.thresh)
    
    def step(self):
        if self.tipo == 'rua':
            if self.model.grade_valor.get_valor(self.pos[0], self.pos[1]) < self.thresh:
                self.move()
                self.move_id = 1
            else:
                self.move_id = 0
                return
        if self.tipo == 'casa':
            if self.model.grade_valor.get_valor(self.pos[0], self.pos[1]) > self.thresh:
                self.move()
                self.move_id = 1
            else:
                self.move_id = 0
                return
        
class MoneyModel(Model):
    '''
    '''
    def __init__(self, N, width, height,
                 casa_shape, casa_scale,
                 rua_mu, rua_sd):
        self.num_agents = N
        self.schedule = RandomActivation(self)
        self.grid = MultiGrid(width, height, True)
        self.grade_valor = Locacao(width, height, self)
        for i in range(self.num_agents):
            if i/self.num_agents > 0.05:
                a = Pessoa(i, self, 'casa', pareto.rvs(b = casa_shape)*casa_scale)
            else:
                a = Pessoa(i, self, 'rua', norm.rvs(rua_mu, rua_sd))
            self.schedule.add(a)
            x = self.random.randrange(self.grid.width)
            y = self.random.randrange(self.grid.height)
            self.grid.place_agent(a, (x, y))
            
        self.datacollector = DataCollector(
            model_reporters={"mobilidade_casa": compute_mobility_casa,
                             "mobilidade_rua": compute_mobility_rua,
                             "gini_espacial_casa": gini_espacial_casa,
                             "gini_espacial_rua": gini_espacial_rua})
            
            
    def step(self):
        self.grade_valor.update_value()
        self.schedule.step()
        self.datacollector.collect(self)

#%%
# parametros: densidade media, casa_shape, casa_scale, rua_mu, rua_sd
dens_mu = np.linspace(40, 60, 3)
casa_shape = np.linspace(1.1, 4, 3)
casa_scale = np.linspace(10, 100, 3)
rua_mu = np.linspace(40, 80, 3)
rua_sd = np.linspace(1, 10, 3)
#%%
it = 20
first = True
for dens in dens_mu:
    for csh in casa_shape:
        for css in casa_scale:
            for rmu in rua_mu:
                for rsd in rua_sd:
                    teste = MoneyModel(int(10*10*dens), 10, 10,
                                       csh, css, 
                                       rmu, rsd)
                    for i in range(it):
                        teste.step()
                    if first:
                        dados_simulacao = teste.datacollector.get_model_vars_dataframe().iloc[-1:]
                        dados_simulacao['dens_mu'] = dens
                        dados_simulacao['casa_shape'] = csh
                        dados_simulacao['casa_scale'] = css
                        dados_simulacao['rua_mu'] = rmu
                        dados_simulacao['rua_sd'] = rsd
                        first = False
                    else:
                        dados_simulacao_atual = teste.datacollector.get_model_vars_dataframe().iloc[-1:]
                        dados_simulacao_atual['dens_mu'] = dens
                        dados_simulacao_atual['casa_shape'] = csh
                        dados_simulacao_atual['casa_scale'] = css
                        dados_simulacao_atual['rua_mu'] = rmu
                        dados_simulacao_atual['rua_sd'] = rsd
                        dados_simulacao = dados_simulacao.append(dados_simulacao_atual)
#%%
# tivemos emergencia com:
# (int(10*10*50), 10, 10, 3, 42, 3, 57)
teste = MoneyModel(int(10*10*50), 10, 10, 3, 42, 71, 5)
#%%
it = 500
for i in range(it):
    teste.step()
#%%
mobilidade = teste.datacollector.get_model_vars_dataframe()
plt.plot(mobilidade['gini_espacial_rua'])
plt.plot(mobilidade['gini_espacial_casa'])
#%%
agent_counts_casa = np.zeros((teste.grid.width, teste.grid.height))
for cell in teste.grid.coord_iter():
    cell_content, x, y = cell
    agent_count = len([pessoa for pessoa in cell_content if pessoa.get_type() == 'casa'])
    agent_counts_casa[x][y] = agent_count
plt.imshow(agent_counts_casa, interpolation='nearest')
plt.colorbar()
#%%
agent_counts_rua = np.zeros((teste.grid.width, teste.grid.height))
for cell in teste.grid.coord_iter():
    cell_content, x, y = cell
    agent_count = len([pessoa for pessoa in cell_content if pessoa.get_type() == 'rua'])
    agent_counts_rua[x][y] = agent_count
plt.imshow(agent_counts_rua, interpolation='nearest')
plt.colorbar()
#%%
vetor_casa = agent_counts_casa.flatten()
vetor_rua = agent_counts_rua.flatten()
plt.scatter(vetor_casa, vetor_rua)
#%%
thresh_casa = []
thresh_rua = []
for agente in teste.schedule.agents:
    if agente.get_type() == 'casa':
        thresh_casa.append(agente.get_thresh())
    if agente.get_type() == 'rua':
        thresh_rua.append(agente.get_thresh())
plt.hist(thresh_rua)
#%%
plt.hist(np.log(thresh_casa))