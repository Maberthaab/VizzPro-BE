const express = require('express');
const { authenticateToken } = require('../../../module/user.module');
const router = express.Router();
const helper = require(__class_dir + '/helper.class.js');
const m$user = require(__module_dir + '/user.module.js');

router.post('/add', async function (req, res, next) {    
    const addUser = await m$user.add(req.body)    
    helper.sendResponse(res, addUser);
});

router.get('/find/:id', async function (req, res, next) {    
    const findUser = await m$user.find(req.params.id)    
    helper.sendResponse(res, findUser);
});

router.put('/update_pass/:id',async function (req, res, next) {    
    const changeUserPass = await m$user.changePass(req.params.id, req.body)    
    helper.sendResponse(res, changeUserPass);
});

router.delete('/delete', async function (req, res, next) {    
    const deleteUser = await m$user.delete(req.body)
    helper.sendResponse(res, deleteUser);
});

router.get('/login', authenticateToken,
 async function (req, res, next) {    
    const login = await m$user.login(req.body)
    helper.sendResponse(res, login);
});


module.exports = router;