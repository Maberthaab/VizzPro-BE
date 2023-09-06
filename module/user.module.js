require('dotenv').config()

const config = require(`${__config_dir}/app.config.json`);
const {debug} = config;
const mysql = new(require(`${__class_dir}/mariadb.class.js`))(config.db);
const Joi =  require('joi');
const jwt = require('jsonwebtoken');
//const { Console } = require('winston/lib/winston/transports');

const _hash = require(`${__class_dir}/hash.class.js`);
class _user{
    add(data){


        // Validate data
        const schema = Joi.object({
            username: Joi.string().required(),
            password: Joi.string().required()
        }).options({
            abortEarly: false
        })
        const validation = schema.validate(data)
        if(validation.error){
            const errorDetails = validation.error.details.map((detail)=>{
                detail.message
            })

            return {
                status: false,
                code: 422,
                error: errorDetails.join(', ')
            }
        }

        // Insert data to database
        const _hashPassword = _hash.md5(data.password)
        const sql = {
            query: `INSERT INTO users (username, password) VALUES (?, ?)`,
            params: [data.username, _hashPassword]
        }

        return mysql.query(sql.query, sql.params)
            .then(data=>{
                return {
                    status: true,
                    data
                }
            })
            .catch(error =>{
                if (debug){
                    console.error('add task Error: ', error)
                }

                return{
                    status: false,
                    error
                }
            })
    }

    changePass(id, data){

        // Validate data
        const schema = Joi.object({
            nPassword: Joi.string()
        }).options({
            abortEarly: false
        })
        const validation = schema.validate(data)
        if(validation.error){
            const errorDetails = validation.error.details.map((detail)=>{
                detail.message
            })

            return {
                status: false,
                code: 422,
                error: errorDetails.join(', ')
            }
        }

        // Update data to database

        const _newHashPassword = _hash.md5(data.nPassword)
        
        const sql = {
            query: `
            UPDATE users
            SET password = ?
            WHERE id = ?
            `,
            params: [_newHashPassword, id]
        }
        

        return mysql.query(sql.query, sql.params)
            .then(data=>{
                if(data.affectedRows === 0){
                    return {
                        status: false,
                        code: 400,
                        error: 'User Id not found'
                    }
                }else{
                    return {
                        status: true,
                        data
                    }
                }
                
            })
            .catch(error =>{
                if (debug){
                    console.error('update task Error: ', error)
                }

                return{
                    status: false,
                    error
                }
            })
    }

    delete(data){

        // Validate data
        const schema = Joi.object({
            id: Joi.number()
        }).options({
            abortEarly: false
        })
        const validation = schema.validate(data)
        if(validation.error){
            const errorDetails = validation.error.details.map((detail)=>{
                detail.message
            })

            return {
                status: false,
                code: 422,
                error: errorDetails.join(', ')
            }
        }

        // Update data to database
        const sql = {
            query: `
            DELETE FROM users
            WHERE id = ?
            `,
            params: [data.id]
        }

        return mysql.query(sql.query, sql.params)
            .then(data=>{
                if(data.affectedRows === 0){
                    return {
                        status: false,
                        code: 400,
                        error: 'User Id not found'
                    }
                }else{
                    return {
                        status: true,
                        data
                    }
                }
            })
            .catch(error =>{
                if (debug){
                    console.error('update task Error: ', error)
                }

                return{
                    status: false,
                    error
                }
            })
    }
    find(data){

        // Find data in database
        const sql = {
            query: `
            SELECT * FROM users
            WHERE id = ?
            `,
            params: [data]
        }

        return mysql.query(sql.query, sql.params)
            .then(data=>{
                return {
                    status: true,
                    data
                }
            })
            .catch(error =>{
                if (debug){
                    console.error('update task Error: ', error)
                }

                return{
                    status: false,
                    error
                }
            })
    }
// ============================================To-do Related================================================
    
    /*authenticateToken(req, res, next){
        const autHeader = req.headers['authorization']
        const token = autHeader && autHeader.split(' ')[1]
        if(token == null) return res.status(500).send({message: "Token required"})
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
            if(err) return res.status(500).send({message: "Token Invalid"})
            req.user = user
            next()
            }
        )
    }
*/


authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = req.header("x-access-token");
    //const token = authHeader && authHeader.split(' ')[1];
    if (!token) {
      return res.status(401).json({ message: "Token required" });
    }  
    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
      if (err) {
        if (err.name === 'TokenExpiredError') {
          return res.status(401).json({ message: "Token expired" });
        }
        return res.status(403).json({ message: "Token invalid" });
      }
      req.user = user;
      next();
    });
  }



    login(data){

        // Validate data
        const schema = Joi.object({
            username: Joi.string(),
            password: Joi.string()
        }).options({
            abortEarly: false
        })
        const validation = schema.validate(data)
        if(validation.error){
            const errorDetails = validation.error.details.map((detail)=>{
                detail.message
            })

            return {
                status: false,
                code: 422,
                error: errorDetails.join(', ')
            }
        }

        // Insert data to database
        const _hashPassword = _hash.md5(data.password)
        const sql = {
            query: `SELECT id, username, password FROM users WHERE username = ?`,
            params: [data.username]
        }

        return mysql.query(sql.query, sql.params)
            .then(data=>{
                if(data[0].password === _hashPassword){
                    const access_token = jwt.sign(data[0].id, process.env.ACCESS_TOKEN_SECRET)
                    return {
                        status: true,
                        message: `Welcome ${data[0].username}`,
                        token: access_token
                    }
                }else{
                    return {
                        status: false,
                        message: `Wrong password`
                    }
                }

            })
            .catch(error =>{
                if (debug){
                    console.error('Login Error: ', error)
                }
                if (error.code === "EMPTY_RESULT"){
                    return{
                        status: false,
                        error: {...error, message: 'User not found'}
                    }
                }

                return{
                    status: false,
                    error
                }
            })
    }
}

module.exports = new _user(this.authenticateToken);
