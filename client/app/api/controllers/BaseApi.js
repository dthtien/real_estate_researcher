import { httpClient } from './httpClient';

export class BaseApi {
  constructor(){
    this.httpClient = httpClient
    this.className = this.constructor
                         .name
                         .split(/(?=[A-Z])/).join('_')
                         .toLowerCase()
                         .replace('_api', '')
  }

  index = (params = {}) =>{
    return this.httpClient().get(this.className, params)
  }

  create = (params) => {
    return this.httpClient().post(this.className, params)
  }

  show = (id) => {
    return this.httpClient().get(`${this.className}/${id}`)
  }

  update = (id, params) => {
    return this.httpClient().patch(`${this.className}/${id}`, params)
  }

  destroy = (id) => {
    return this.httpClient().delete(`${this.className}/${id}`)
  }
}
