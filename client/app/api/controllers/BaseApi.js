/* eslint-disable quotes */
import httpClient from "utils/httpClient";

export default class BaseApi {
  constructor() {
    this.httpClient = httpClient;
    this.className = this.constructor.name
      .split(/(?=[A-Z])/)
      .join("_")
      .toLowerCase()
      .replace("_api", "");
  }

  index = (params = {}) =>
    this.httpClient()
      .get(this.className, params)
      .then(response => response.data.data)
      .catch(err => { throw err; });

  create = params =>
    this.httpClient()
      .post(this.className, params)
      .then(response => response.data)
      .catch(err => { throw err; });

  show = id =>
    this.httpClient()
      .get(`${this.className}/${id}`)
      .then(response => response.data)
      .catch(err => { throw err; });

  update = (id, params) =>
    this.httpClient().patch(`${this.className}/${id}`, params)
      .then(response => response.data)
      .catch(err => { throw err; });;

  destroy = id =>
    this.httpClient().delete(`${this.className}/${id}`)
      .then(response => response.data)
      .catch(err => { throw err; });;
}
