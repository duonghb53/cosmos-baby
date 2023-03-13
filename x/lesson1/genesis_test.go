package lesson1_test

import (
	"testing"

	"github.com/stretchr/testify/require"
	keepertest "lesson_1/testutil/keeper"
	"lesson_1/testutil/nullify"
	"lesson_1/x/lesson1"
	"lesson_1/x/lesson1/types"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		Params: types.DefaultParams(),

		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.Lesson1Keeper(t)
	lesson1.InitGenesis(ctx, *k, genesisState)
	got := lesson1.ExportGenesis(ctx, *k)
	require.NotNil(t, got)

	nullify.Fill(&genesisState)
	nullify.Fill(got)

	// this line is used by starport scaffolding # genesis/test/assert
}
