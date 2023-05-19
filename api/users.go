package api

import (
	"database/sql"
	"fmt"
	"net/http"

	db "github.com/duyvo689/sharkhome/db/sqlc"
	"github.com/gin-gonic/gin"
	"github.com/lib/pq"
)

type CreateUserParams struct {
	Email          string         `json:"email"`
	Phone          string         `json:"phone"`
	Avatar         sql.NullString `json:"avatar"`
	FullName       string         `json:"full_name"`
	HashedPassword string         `json:"hashed_password"`
	UserRole       string         `json:"user_role"`
}

func (server *Server) createUser(ctx *gin.Context) {

	var req CreateUserParams
	fmt.Println(req)

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	arg := db.CreateUserParams{
		Email:          req.Email,
		Phone:          req.Phone,
		Avatar:         req.Avatar,
		FullName:       req.FullName,
		HashedPassword: req.HashedPassword,
	}
	account, err := server.store.CreateUser(ctx, arg)
	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			switch pqErr.Code.Name() {
			case "foreign_key_violation", "unique_violation":
				ctx.JSON(http.StatusForbidden, errorResponse(err))
				return
			}
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, account)
}

type getUserRequest struct {
	ID int64 `uri:"id" binding:"required,min=1"`
}

func (server *Server) getUser(ctx *gin.Context) {

	var req getUserRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.store.GetUser(ctx, req.ID)

	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, user)
}
