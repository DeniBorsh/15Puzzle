#include "gameboard.h"
#include <algorithm>
#include <chrono>
#include <random>
#include <QDebug>

namespace {
bool isAdjacent(GameBoard::Position f,
                GameBoard::Position s)
{
    if (f == s) return false;

    if (f.first == s.first && abs(f.second - s.second) == 1)
        return true;
    else if (f.second == s.second && abs(f.first - s.first) == 1)
        return true;

    return false;
}
}

GameBoard::GameBoard(const int boardDimension, QObject *parent)
    : QAbstractListModel {parent}
    , m_dimension {boardDimension}
    , m_boardSize {boardDimension * boardDimension}
    , m_movements {0}
{
    m_rawBoard.resize(m_boardSize);
    std::iota(m_rawBoard.begin(), m_rawBoard.end(), 1);
    shuffle();
}

int GameBoard::rowCount(const QModelIndex &parent) const
{
    return m_rawBoard.size();
}

QVariant GameBoard::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() || role != Qt::DisplayRole)
        return {};
    const int rowIndex {index.row()};

    if(!isPositionValid(rowIndex)) return {};

    return QVariant::fromValue(m_rawBoard[rowIndex].value);
}

int GameBoard::dimension() const
{
    return m_dimension;
}

int GameBoard::boardSize() const
{
    return m_boardSize;
}

int GameBoard::movements() const
{
    return m_movements;
}

void GameBoard::setMovements(int n)
{
    m_movements = n;
}

bool GameBoard::move(int index)
{
    if (!isPositionValid(index)) return false;
    Position element {getRowCol(index)};

    auto hiddenElementIt = std::find(m_rawBoard.begin(), m_rawBoard.end(), m_boardSize);
    int hiddenElementIndex = std::distance(m_rawBoard.begin(), hiddenElementIt);
    Position hiddenElement {getRowCol(hiddenElementIndex)};
    if (!isAdjacent(hiddenElement, element)) return false;

    const QModelIndex parentIndex = QModelIndex();

    beginMoveRows(parentIndex, index, index,
                  parentIndex, hiddenElementIndex + (hiddenElementIndex > index));
    endMoveRows();

    std::swap(*(hiddenElementIt), m_rawBoard[index]);
    emit movementsChanged(++m_movements);
    emit dataChanged(createIndex(0, 0), createIndex(m_boardSize, 0));
    if (isRightOrder()) emit finished(m_movements);
    return true;
}

GameBoard::Position GameBoard::getRowCol(int index) const
{
    int row = index / m_dimension;
    int col = index % m_dimension;
    return {row, col};
}

void GameBoard::shuffle()
{
    auto seed = std::chrono::system_clock::now().time_since_epoch().count();
    static std::mt19937 generator(seed);
    do {
        std::shuffle(m_rawBoard.begin(), m_rawBoard.end(), generator);
    } while (!isBoardValid());

    emit dataChanged(createIndex(0, 0), createIndex(m_boardSize, 0));
    emit movementsChanged(m_movements = 0);

}

bool GameBoard::isPositionValid(const int pos) const
{
    return pos >= 0 && pos < m_boardSize;
}

bool GameBoard::isBoardValid() const
{
    int inv {0};
    for (int i {0}; i < m_boardSize; ++i)
        for (int j = 0; j < i; ++j)
            if (m_rawBoard[j].value > m_rawBoard[i].value)
                ++inv;
    const int startPoint {1};
    for (int i = 0; i < m_boardSize; ++i)
        if (m_rawBoard[i].value == m_boardSize)
            inv += startPoint + 1 / m_dimension;
    return (inv % 2) == 0;
}

bool GameBoard::isRightOrder() const
{
    for (int i = 0; i < m_boardSize; ++i)
        if (m_rawBoard[i].value != i+1) return false;
    return true;
}
