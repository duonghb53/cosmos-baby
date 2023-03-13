package keeper_test

import (
	"testing"

	"github.com/stretchr/testify/require"
	testkeeper "lesson_1/testutil/keeper"
	"lesson_1/x/lesson1/types"
)

func TestGetParams(t *testing.T) {
	k, ctx := testkeeper.Lesson1Keeper(t)
	params := types.DefaultParams()

	k.SetParams(ctx, params)

	require.EqualValues(t, params, k.GetParams(ctx))
}
